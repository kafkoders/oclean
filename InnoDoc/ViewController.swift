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
import Malert

import web3swift
import BigInt

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var changeMapButton: UIButton!
    
    var locationManager: CLLocationManager!
    var latestCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var okAction: UIAlertAction!
    
    var activePoints = [Pin]()
    
    var walletAddress: String!
    var infura: Web3!

    let jsonContract = "[{\"constant\":false,\"inputs\":[{\"name\":\"_containerAddress\",\"type\":\"address\"},{\"name\":\"_latitude\",\"type\":\"string\"},{\"name\":\"_longitude\",\"type\":\"string\"}],\"name\":\"createContainer\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_fillingPercentage\",\"type\":\"uint256\"}],\"name\":\"set\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"throwFireAlarm\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"containerId\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"containerAddress\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"latitude\",\"type\":\"string\"},{\"indexed\":false,\"name\":\"longitude\",\"type\":\"string\"}],\"name\":\"LogNewContainer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"containerId\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"fillingPercentage\",\"type\":\"uint256\"}],\"name\":\"LogNewFilling\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"containerId\",\"type\":\"uint256\"}],\"name\":\"LogFireAlarm\",\"type\":\"event\"},{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"containerToOwner\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getAllContainers\",\"outputs\":[{\"components\":[{\"name\":\"containerAddress\",\"type\":\"address\"},{\"name\":\"latitude\",\"type\":\"string\"},{\"name\":\"longitude\",\"type\":\"string\"},{\"name\":\"fillingPercentage\",\"type\":\"uint256\"}],\"name\":\"\",\"type\":\"tuple[]\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_containerId\",\"type\":\"uint256\"}],\"name\":\"getContainer\",\"outputs\":[{\"name\":\"containerAddress\",\"type\":\"address\"},{\"name\":\"latitude\",\"type\":\"string\"},{\"name\":\"longitude\",\"type\":\"string\"},{\"name\":\"fillingPercentage\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"getContainerLenght\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"}]"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeMapButton.layer.shadowColor = UIColor.black.cgColor
        changeMapButton.layer.shadowOffset = .zero
        changeMapButton.layer.masksToBounds = false
        changeMapButton.layer.shadowOpacity = 1.0
        changeMapButton.layer.shadowRadius = 5
        
        // Registramos las clases y el delegado.
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(PinAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterPinView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        /*
         * Zona de peticiones al servidor.
                Se le pide al servidor todo el contenido que responderá como JSON, parsearemos y añadiremos al mapa.
 
        Alamofire.request(serverIP + "index.php?controller=Usuarios&action=api").responseJSON { (response) in
*/
        
        infura = Web3(infura: .rinkeby, accessToken: "a071903b67d847eda9080886d341b96a")
        updateFromBC(self)
        
        // Obtenemos el número de monedas del wallet.
        if let data = UserDefaults.standard.value(forKey: "walletData") as? Data, let address = UserDefaults.standard.value(forKey: "walletAddress") as? String {
            print("Wallet creada. Decodifico")
            //let result = try? JSONDecoder().decode(KeystoreParamsV3.self, from: data)
            //print(result)

            
            self.walletAddress = address
//            let amount = getWalletAmount(walletAddress: address, web3: infura)
//            print("Amount: \(amount)")
        } else {
            print("Creo nueva wallet")
            newWallet()
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
     * Zona de Interacción con el usuario.
     */
    
    /*
     * @IBAction func showAskMenu(_ sender: Any) {
            Muestra un AlertController de tipo View donde el usuario puede escribir la pregunta.
            Cuando se le da al botón de enviar se conecta al servidor.
     */
    @IBAction func showAskMenu(_ sender: Any) {
        // Lógica de funcionamiento para mañana: (que al leer esto mañana será hoy)
        // Y al leerlo otro día tiempo pasado
        
        /*
         La manera más eficiente computacionalmente de hacerlo es relacionando puntos entre si
         esto es, para ir de A -> F, pasando por los intermedios, tendrá que ser secuencial
         
         Aunque no es eficiente para calcular la ruta, es lo más simple de calcular.
         Esto debe ser, para ir de A->F, del tipo A->B B->C C->D D->E E->F
        */
        
        for i in 0...self.activePoints.count {
            // Se tendrá que tomar el punto actual (i) y el siguiente (i+1)
            // Pese a que no tengan continuidad geográfica. Cuidado
            if i == self.activePoints.count-1 { break }

            //if
                let source = MKMapItem(placemark: MKPlacemark(coordinate: self.mapView.annotations[i].coordinate, addressDictionary: nil))
                let dest = MKMapItem(placemark: MKPlacemark(coordinate: self.mapView.annotations[i+1].coordinate, addressDictionary: nil))// {
            
                let directionRequest = MKDirections.Request()
                directionRequest.source = source
                directionRequest.destination = dest
                directionRequest.transportType = .automobile

                // Calculate the direction
                let directions = MKDirections(request: directionRequest)
                
                // 8.
                directions.calculate {
                    (response, error) -> Void in
                    
                    guard let response = response else {
                        if let error = error {
                            print("Error: \(error)")
                        }
                        
                        return
                    }
                    
                    let route = response.routes[0]
                    self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                    
                    let rect = route.polyline.boundingMapRect
                    self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                }
            //}
            
        }
    }
    
    
    @IBAction func updateFromBC(_ sender: Any) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        let ethContractAddress = Address("0x00407706920cd607f1f8a745e50572f41d9dd349")
        
        let contract = try! infura.contract(jsonContract, at: ethContractAddress)
        
        var options = Web3Options.default
        options.from = Address(stringLiteral: "0x7B738EA61B2fa1fA6F30C2B9cBF64261fd3e97A5")
        
        
        let getLenght = try! contract.method("getContainerLenght", parameters:[] as [AnyObject], options: options)
        do {
            let resultL = try getLenght.call(options: options)
            print(resultL.dictionary)
            
            if let lenght = resultL.dictionary["0"]! as? BigUInt {
                for i in 0...Int(lenght-1) {
                    let transactionIntermediate = try! contract.method("getContainer", parameters:[i] as [AnyObject], options: options)
                    
                    let result = try transactionIntermediate.call(options: options)
                    print(result.dictionary)
                    
                    
                    if let latitude = (result.dictionary["latitude"] as? NSString)?.doubleValue,
                        let longitude = (result.dictionary["longitude"] as? NSString)?.doubleValue,
                        let fillingPercentage = result.dictionary["fillingPercentage"] as? BigUInt {
                        
                        print(latitude)
                        print(longitude)
                        print(fillingPercentage)
                        
                        self.mapView.addAnnotation(Pin(id: "a\(i)", fillingPercentage: Int(fillingPercentage), coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
                    }
                }
                
                // Para prototipado, aplicamos datos estáticos
                self.mapView.addAnnotation(Pin(id: "1", fillingPercentage: 80, coordinate: CLLocationCoordinate2D(latitude: 40.385137, longitude: -5.772677)))
                self.mapView.addAnnotation(Pin(id: "2", fillingPercentage: 30, coordinate: CLLocationCoordinate2D(latitude: 40.382149, longitude:  -5.767989)))
                self.mapView.addAnnotation(Pin(id: "3", fillingPercentage: 95, coordinate: CLLocationCoordinate2D(latitude: 40.38874, longitude: -5.777986)))
                
                self.activePoints.removeAll()
                for annotation in self.mapView.annotations {
                    if let annotation = annotation as? Pin, annotation.fillingPercentage > 70 {
                        print("id: \(annotation.id), perc: \(annotation.fillingPercentage)")
                        
                        self.activePoints.append(annotation)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func goToWallet(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let walletVC = storyboard.instantiateViewController(withIdentifier: "walletVC") as? WalletViewController {
            walletVC.address = self.walletAddress
            walletVC.web3 = self.infura
            
            self.present(walletVC, animated: true, completion: nil)
        }
    }
    
    
    func newWallet() {
        if let wallet = createWallet(name: "Carlos' Wallet", password: "bisite00"), let data = wallet.data {
            UserDefaults.standard.set(data, forKey: "walletData")
            UserDefaults.standard.set(wallet.address, forKey: "walletAddress")
            
            print("Todo OK")
        }
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
    
    @IBAction func showLegal(_ sender: Any) {
        let legalView = TextFieldAlertView.instantiateFromNib()
        
        let alert = Malert(customView: legalView, tapToDismiss: false)
        
        let dismissAction = MalertAction(title: "OK")
        dismissAction.tintColor = .gray
        alert.addAction(dismissAction)
        
        present(alert, animated: true)
    }
    
}

extension ViewController: MKMapViewDelegate {
    // Mostramos la vista especial solo para los pin únicos. Para los cluster no se aplica.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Pin else { return nil }
        return PinAnnotationView(annotation: annotation, reuseIdentifier: "pinReuseID", status: annotation.fillingPercentage > 70)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKOverlayRenderer()
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
            ViewController.loadQuestionPopUp(pin: annotation, sender: self)
            
            mapView.deselectAnnotation(annotation, animated: true)
            
        }
    }
    
    public static func loadQuestionPopUp(pin: Pin, sender: UIViewController) {
        let view = PinDetailView.instantiateFromNib()
        view.loadQuestion(pin: pin)
        
        let alert = Malert(customView: view, tapToDismiss: false)
        alert.buttonsAxis = .horizontal
        alert.separetorColor = .clear
        alert.cornerRadius = 20
        alert.animationType = .fadeIn
        alert.presentDuration = 0.6
        
        let firstAction = MalertAction(title: "Aceptar") {
            print("Dismiss")
        }
        
        firstAction.tintColor = UIColor.lightGray
        alert.addAction(firstAction)
        
        sender.present(alert, animated: true)
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
        
        // Centramos la ubicación inicial del mapa en las coordenadas centrales de Salamanca.
        let initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let searchRadius: CLLocationDistance = 2000
        
        let region = MKCoordinateRegion.init(center: initialLocation.coordinate, latitudinalMeters: searchRadius*2.0, longitudinalMeters: searchRadius * 2.0)
        mapView.setRegion(region, animated: true)
        
    }
}
