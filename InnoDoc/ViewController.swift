//
//  ViewController.swift
//  InnoDoc
//
//  Created by Carlos on 11/03/2019.
//  Copyright © 2019 Carlos. All rights reserved.
//

import UIKit
import MapKit

import KUIPopOver
import Alamofire
import MBProgressHUD

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    
    var locationManager: CLLocationManager!
    var latestCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var okAction: UIAlertAction!
    
    let serverIP = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ponemos bonito el botón.
        addButton.layer.cornerRadius = 15
        addButton.backgroundColor = UIColor(red:0.20, green:0.60, blue:1.00, alpha:1.0)
        addButton.alpha = 0.8
        
        let initialLocation = CLLocation(latitude: 40.9688200, longitude: -5.6638800)
        let searchRadius: CLLocationDistance = 2000
        
        mapView.delegate = self
        
        let region = MKCoordinateRegion.init(center: initialLocation.coordinate, latitudinalMeters: searchRadius*2.0, longitudinalMeters: searchRadius * 2.0)
        mapView.setRegion(region, animated: true)
        
        //Alamofire.request(serverIP + "")
        Alamofire.request(serverIP + "").responseJSON { (response) in
            if let data = response.result.value as? [[String: Any]] {
                for pin in data {
                    // La respuesta deberá ser del tipo ["username": "", "coordinates": "" ,...]
                    if let id = pin["id"] as? Int,
                        let username = pin["username"] as? String,
                        let latitude = pin["coordinate_lat"] as? Double,
                        let longitude = pin["coordinate_long"] as? Double,
                        let question = pin["question"] as? String,
                        let answer = pin["answer"] as? String {
                        
                        self.addPin(id: id, question: question, answer: answer, coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                    }
                }
            }
        }
        
        // Obtenemos la posición GPS
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if !UserDefaults.standard.bool(forKey: "userEmail") {
            askEmail()
        }
    }
    func askEmail() {
        let alert = UIAlertController(title: "Establecer E-Mail", message: "Para poder utilizar esta aplicación es necesario que nos indique su correo electrónico y un nombre de usuario.", preferredStyle: .alert)
        
        var mailTField = UITextField()
        var userTField = UITextField()
        
        alert.addTextField { (textField) in
            mailTField = textField
            
            textField.tag = 10
            textField.placeholder = "Nombre de usuario"
            textField.keyboardType = .emailAddress
            textField.delegate = self
        }
        
        alert.addTextField { (textField) in
            userTField = textField
            
            textField.tag = 11
            textField.placeholder = "E-Mail"
            textField.keyboardType = .emailAddress
            textField.delegate = self
        }
        
        okAction = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
            if let mail = mailTField.text, let username = userTField.text {
                UserDefaults.standard.set(mail, forKey: "userEmail")
                UserDefaults.standard.set(username, forKey: "userName")
            }
        })
        okAction.isEnabled = false
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addPin(id: Int, question: String, answer: String, coordinates: CLLocationCoordinate2D) {
        mapView.addAnnotation(Pin(id: id, question: question, answer: answer, coordinate: coordinates))
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? Pin {
            print("ID: \(annotation.id), titulo: \(annotation.question)")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let pinDetailVC = storyboard.instantiateViewController(withIdentifier: "pinDetailView") as? PinDetailViewController {
                pinDetailVC.pin = annotation
                
                pinDetailVC.showPopoverWithNavigationController(sourceView: view, shouldDismissOnTap: false)
            }
            
        }
    }
    
    @IBAction func showAskMenu(_ sender: Any) {
        while !UserDefaults.standard.bool(forKey: "userEmail") {
            askEmail()
        }
        
        let alert = UIAlertController(title: "Preguntar", message: "¡Preguntenos lo que quiera! Puede hacerlo escribiendo aqui:", preferredStyle: .alert)
        var tField = UITextField()
        
        alert.addTextField { (textField) in
            tField = textField
            textField.placeholder = "Pregunta"
        }
        
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .indeterminate
            hud.label.text = "Subiendo pregunta"
            
            if let question = tField.text,
                let username = UserDefaults.standard.value(forKey: "userName"),
                let userMail = UserDefaults.standard.value(forKey: "userEmail") {
                
                let queryData: Parameters = ["user": username, "mail": userMail, "coordinate_lat": self.latestCoordinates.latitude, "coordinate_long": self.latestCoordinates.longitude, "question": question]
                
                Alamofire.request(self.serverIP + "", method: .post, parameters: queryData).response(completionHandler: { (response) in
                    if let code = response.response?.statusCode, code == 200 {
                        print("Consulta hecha OK")
                        hud.hide(animated: true)
                    } else {
                        hud.mode = .text
                        hud.label.text = "Error subiendo pregunta."
                        hud.hide(animated: true, afterDelay: 2)
                    }
                })
            } else {
                hud.mode = .text
                hud.label.text = "Error subiendo pregunta."
                hud.hide(animated: true, afterDelay: 2)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let userEnteredString = textField.text
        let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
        
        if newString == "" {
            self.okAction.isEnabled = false
        } else {
            self.okAction.isEnabled = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latestCoordinates = locValue
        self.locationManager.stopUpdatingLocation()
    }
}

class PinDetailViewController: UIViewController, KUIPopOverUsable {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    var pin: Pin?
    
    private lazy var size: CGSize = {
        return CGSize(width: 270.0, height: 185)
    }()
    
    var contentSize: CGSize {
        return size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = size
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let pin = pin {
            questionLabel.text = pin.question
            answerLabel.text = pin.answer
        }
    }
    
    @IBAction func seeMoreAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "questionDetailVC") as? QuestionDetailVC {
            
            if let pin = pin {
                vc.answer = pin.answer
                vc.question = pin.question
                
                self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        }
    }
}
