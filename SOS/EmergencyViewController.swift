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
    
    @IBOutlet var Input: UITextField!
    @IBOutlet var Label: UILabel!
    @IBOutlet var Button: UIButton!
    @IBOutlet var LocationLabel: UILabel!
    
    var ememergencyNumbers: EmergencyNumbers?

    override func viewDidLoad() {
        super.viewDidLoad()
        /*Button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        Button.layer.cornerRadius = 0.5 * Button.bounds.size.width
        Button.clipsToBounds = true*/
        
        ParseJSON()
        print((ememergencyNumbers?.numbers[0].Police.All.first)!!)
        
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        for number in (ememergencyNumbers?.numbers)! {
            if (number.Country.ISOCode == Input.text){
                Label.text = number.Police.All.first!!
            }
        }
    }
    
    
    @IBAction func LocationButtonPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
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
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else{
            return
            
        }
        print("locations = \(locationValue.latitude) \(locationValue.longitude)")
        LocationLabel.text = "\(locationValue.latitude) \(locationValue.longitude)"
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to find user's location: \(error.localizedDescription)")
      }
}
