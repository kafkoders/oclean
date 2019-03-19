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

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var changeMapButton: UIButton!
    
    var locationManager: CLLocationManager!
    var latestCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var okAction: UIAlertAction!
    
    let serverIP = "https://vm-bisite-09.der.usal.es/"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ponemos bonitos los botone.
        addButton.layer.cornerRadius = 15
        addButton.backgroundColor = UIColor(red:0.20, green:0.60, blue:1.00, alpha:1.0)
        addButton.alpha = 0.8
        
        changeMapButton.layer.shadowColor = UIColor.black.cgColor
        changeMapButton.layer.shadowOffset = .zero
        changeMapButton.layer.masksToBounds = false
        changeMapButton.layer.shadowOpacity = 1.0
        changeMapButton.layer.shadowRadius = 5
        
        // Centramos la ubicación inicial del mapa en las coordenadas centrales de Salamanca.
        let initialLocation = CLLocation(latitude: 40.9688200, longitude: -5.6638800)
        let searchRadius: CLLocationDistance = 2000
        
        let region = MKCoordinateRegion.init(center: initialLocation.coordinate, latitudinalMeters: searchRadius*2.0, longitudinalMeters: searchRadius * 2.0)
        mapView.setRegion(region, animated: true)
        
        
        // Registramos las clases y el delegado.
        mapView.delegate = self
        mapView.register(PinAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterPinView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        /*
         * Zona de peticiones al servidor.
                Se le pide al servidor todo el contenido que responderá como JSON, parsearemos y añadiremos al mapa.
         */
        Alamofire.request(serverIP + "index.php?controller=Usuarios&action=api").responseJSON { (response) in

            if let data = response.result.value as? [[String: Any]] {
                for pin in data {
                    
                    if let id = (pin["id"] as? NSString)?.intValue,
                        let username = pin["usuario"] as? String,
                        let latitude = (pin["latitud"] as? NSString)?.doubleValue,
                        let longitude = (pin["longitud"] as? NSString)?.doubleValue,
                        let category = pin["categoria"] as? String,
                        let question = pin["pregunta"] as? String,
                        let answer = pin["respuesta"] as? String {
                        
                        self.addPin(id: Int(id), username: username, category: category, question: question, answer: answer, coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                    }
                }
            }
        }
        
        // Comprobamos si se ha introducido el e-mail por parte del usuario. Si no es así, se le insiste.
        if UserDefaults.standard.value(forKey: "userEmail")  == nil {
             askEmail()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Obtenemos e inicializamos la posición GPS. Se cancelará cuando tenga 2 valores correctos para ser más eficiente con la batería.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /*
     * func addPin -> void
     *      Pasa los argumentos necesarios para poder crear un pin y añadirlo al mapa, como la clase Pin.
     *      Cada uno de los argumentos corresponde a su valor en la clase Pin.
     */
    func addPin(id: Int, username: String, category: String, question: String, answer: String, coordinates: CLLocationCoordinate2D) {
        mapView.addAnnotation(Pin(id: id, username: username, category: category, question: question, answer: answer, coordinate: coordinates))
    }
    
    
    /*
     * Zona de Interacción con el usuario.
     */
    
    /*
     * func askEmail()
            Muestra un AlertController de tipo View con dos TextField (nombre de usuario y email)
     */
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
    
    /*
     * @IBAction func showAskMenu(_ sender: Any) {
            Muestra un AlertController de tipo View donde el usuario puede escribir la pregunta.
            Cuando se le da al botón de enviar se conecta al servidor.
     */
    @IBAction func showAskMenu(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "userEmail") == nil {
            askEmail()
        }
        
        let alert = UIAlertController(title: "Preguntar", message: "¡Preguntenos lo que quiera! Puede hacerlo escribiendo aqui:", preferredStyle: .alert)
        var tField = UITextField()
        
        alert.addTextField { (textField) in
            tField = textField
            textField.placeholder = "Pregunta"
            textField.autocorrectionType = .yes
        }
        
        
        // Al pulsar el botón de enviar muestra el HUD y envia la pregunta al servidor.
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .indeterminate
            hud.label.text = "Subiendo pregunta"
            
            if let question = tField.text,
                let username = UserDefaults.standard.value(forKey: "userName"),
                let userMail = UserDefaults.standard.value(forKey: "userEmail") {
                
                let queryData: Parameters = ["user": username, "mail": userMail, "coordinate_lat": self.latestCoordinates.latitude, "coordinate_long": self.latestCoordinates.longitude, "question": question]
                
                Alamofire.request(self.serverIP + "index.php?controller=Usuarios&action=getJSON", method: .post, parameters: queryData).response(completionHandler: { (response) in
                    // Si el código es un 200, correcto. Procedemos.
                    if let code = response.response?.statusCode, code == 200 {
                        print("Consulta hecha OK")
                        hud.hide(animated: true)
                    } else {
                        // Ha habido un error. Mostramos y cancelamos.
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
    
    @IBAction func changeMode(_ sender: Any) {
        if mapView.mapType == .standard {
            mapView.mapType = .satelliteFlyover
            changeMapButton.setImage(#imageLiteral(resourceName: "map"), for: .normal)
        } else {
            mapView.mapType = .standard
            changeMapButton.setImage(#imageLiteral(resourceName: "earth"), for: .normal)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    // Mostramos la vista especial solo para los pin únicos. Para los cluster no se aplica.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Pin else { return nil }
        return PinAnnotationView(annotation: annotation, reuseIdentifier: "pinReuseID")
    }
    
    // Cuando pulsan sobre una de ellas se actúa en consecuencia.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if view.annotation is MKClusterAnnotation {
            if let multiPinTVC = storyboard.instantiateViewController(withIdentifier: "multipinTVC") as? MultiPinTVC,
                let cluster = view.annotation as? MKClusterAnnotation,
                let pinData = cluster.memberAnnotations as? [Pin] {
                
                multiPinTVC.pinData = pinData
                multiPinTVC.showPopover(sourceView: view, shouldDismissOnTap: true)
            }
        } else if let annotation = view.annotation as? Pin {
            if let pinDetailVC = storyboard.instantiateViewController(withIdentifier: "pinDetailView") as? PinDetailViewController {
                pinDetailVC.pin = annotation
                
                pinDetailVC.showPopoverWithNavigationController(sourceView: view, shouldDismissOnTap: true)
            }
            
            mapView.deselectAnnotation(annotation, animated: true)
            
        }
    }
}

extension ViewController: UITextFieldDelegate {
    // Comprobamos el número de caracteres para habilitar o no el botón de OK.
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
    
    // Deshabilitamos la tecla "Return" del teclado.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}

extension ViewController: CLLocationManagerDelegate {
    // Comprobamos y actualizamos las coordenadas del usuario.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latestCoordinates = locValue
        print(latestCoordinates)
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
                vc.pin = pin
                
                self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
            }
        }
    }
}
