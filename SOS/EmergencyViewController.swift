//
//  ViewController.swift
//  SOS
//
//  Created by Olej Ádám on 2022. 04. 26..
//

import UIKit
import MapKit
import CoreLocation

class EmergencyViewController: UIViewController{
    let locationManager = CLLocationManager()
    
    @IBOutlet var Label: UILabel!
    @IBOutlet var LocationLabel: UILabel!
    
    var ememergencyNumbers: EmergencyNumbers?
    var country: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        /*Button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        Button.layer.cornerRadius = 0.5 * Button.bounds.size.width
        Button.clipsToBounds = true*/
        
        ParseJSON()
        
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    @IBAction func LocationButtonPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    func showSOSActionSheet(){
        print(country!)
        
        let actionSheet = UIAlertController(title: "Hívás", message: "Melyik szervet szeretnéd felhívni?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Mentő", style: .default, handler: { action in
            for number in (self.ememergencyNumbers?.numbers)! {
                if (number.Country.Name.contains(self.country!)){
                    let phoneNumber = number.Ambulance.All.first!!
                    self.manageSOSAction(type: "Mentő", phoneNumber: Int(phoneNumber)!)
                    return
                }
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Rendőr", style: .default, handler: { action in
            for number in (self.ememergencyNumbers?.numbers)! {
                if (number.Country.Name.contains(self.country!)){
                    let phoneNumber = number.Police.All.first!!
                    self.manageSOSAction(type: "Rendőr", phoneNumber: Int(phoneNumber)!)
                    return
                }
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Tűzoltó", style: .default, handler: { action in
            for number in (self.ememergencyNumbers?.numbers)! {
                if (number.Country.Name.contains(self.country!)){
                    let phoneNumber = number.Fire.All.first!!
                    self.manageSOSAction(type: "Tűzoltó", phoneNumber: Int(phoneNumber)!)
                    return
                }
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Mégse", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func manageSOSAction(type: String, phoneNumber: Int){
        Label.text = ("\(type) hívása \(phoneNumber) számon")
        print("call \(type) with \(phoneNumber)")
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    private func ParseJSON(){
        guard let path = Bundle.main.path(forResource: "List-Of-Emergency-Telephone-Numbers", ofType: "json") else{
            return
        }
        let url = URL(fileURLWithPath: path)
        do{
            let jsonData = try Data(contentsOf: url)
            ememergencyNumbers = try JSONDecoder().decode(EmergencyNumbers.self, from: jsonData)
            
            /*if let result = ememergencyNumbers{
                //print(result)
            } else{
                print("Failed to parse")
            }*/
            return
        } catch{
            print("Error \(error)")
        }
    }
}

extension EmergencyViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate: CLLocationCoordinate2D = manager.location?.coordinate else{return}
        guard let location: CLLocation = manager.location else { return }
        
        locationManager.stopUpdatingLocation()
        
        print("locations = \(coordinate.latitude) \(coordinate.longitude)")
        LocationLabel.text = "\(coordinate.latitude) \(coordinate.longitude)"
        
        fetchCityAndCountry(from: location) { city, country, error in
            guard let city = city, country != nil, error == nil else { return }
            self.country = country
            print(city + ", " + self.country!)
            self.showSOSActionSheet()
            }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to find user's location: \(error.localizedDescription)")
      }
}
