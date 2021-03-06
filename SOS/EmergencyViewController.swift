//
//  ViewController.swift
//  SOS
//
//  Created by Olej Ádám on 2022. 04. 26..
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class EmergencyViewController: UIViewController{
    
    let locationManager = CLLocationManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var users: [NSManagedObject] = []
    var ememergencyNumbers: EmergencyNumbers?
    var country: String?
    var text: String = String()
    var coord: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        ParseJSON()
        
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadUser()
    }
    
    @IBAction func SOSButtonPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    func showSOSActionSheet() {
        print(country!)
        let actionSheet = UIAlertController(title: "Hívás", message: "Melyik segélyhívó számot szeretné felhívni?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Mentő", style: .default, handler: { action in
            self.manageSOSAction(type: "ambulance")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Rendőr", style: .default, handler: { action in
            self.manageSOSAction(type: "police")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Tűzoltó", style: .default, handler: { action in
            self.manageSOSAction(type: "fire")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Mégse", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func manageSOSAction(type: String) {
        var phoneNumber = String()
        var hunType = String()
        var hunTypeinfl = String()
        for number in (ememergencyNumbers?.numbers)! {
            if (number.Country.Name.contains(country!)){
                switch type {
                case "police":
                    phoneNumber = number.Police.All.first!!
                    hunType = "Rendőr"
                    hunTypeinfl = "rendőrt"
                    
                case "fire":
                    phoneNumber = number.Fire.All.first!!
                    hunType = "Tűzoltó"
                    hunTypeinfl = "tűzoltót"

                default:
                    phoneNumber = number.Ambulance.All.first!!
                    hunType = "Mentő"
                    hunTypeinfl = "mentőt"
                }
                break
            }
        }
        
        loadUser()
        makeSMSText(typeinfl: hunTypeinfl)
        let alert = UIAlertController(title: "Hívás", message: "\(hunType) hívása a \(phoneNumber) számon." + text ,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
        print("call \(type) with \(phoneNumber)")
    }
    
    func loadUser() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            users = try context.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        
        if (users.isEmpty) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let editVC = storyboard.instantiateViewController(withIdentifier: "EditViewController")
            show(editVC, sender: self)
        }
    }
    
    func makeSMSText(typeinfl: String) {
        if (!users.isEmpty) {
            let name = users[0].value(forKeyPath: "name") as? String
            let address = users[0].value(forKeyPath: "address") as? String
            let TAJ = String((users[0].value(forKey: "taj_number") as? Int32 ?? 0))
            let birthPlace = users[0].value(forKeyPath: "birth_place") as? String
            let birthDate = (users[0].value(forKeyPath: "birth_date") as? Date ?? Date.now).description.split(separator: " ").first
            let bloodType = users[0].value(forKeyPath: "blood_type") as? String
            let diseases = users[0].value(forKeyPath: "diseases") as? String
            let medicines = users[0].value(forKeyPath: "medicines") as? String
            let SMS = users[0].value(forKeyPath: "sms_text") as? String
            let contactName = users[0].value(forKeyPath: "contact_name") as? String
            let contactPhone = users[0].value(forKeyPath: "contact_phone") as? String
            
            text = "\n\n SMS küldése a \(contactPhone!) számra.\n\n\n Kedves \(contactName!)!\n\n\(name!) \(typeinfl) hívott az SOS alkalmazás segítségével. \nAz alábbi SMS szöveggel:\n\n \(SMS!)\n\nTartózkodási koordinátái: \(coord!.latitude) \(coord!.longitude)\nTAJ száma: \(TAJ)\nSzületési adtai: \(birthPlace!), \(birthDate!)\nLakcíme: \(address!)\nVércsoportja: \(bloodType!)\nBetegségei: \n\(diseases!)\nSzedett gyógyszerei: \n\(medicines!)"
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
            if (error != nil) {
                let alert = UIAlertController(title: "Nincs hálózati kapcsolat", message: "Az ország lekérdezéséhez internetkapcsolat szükséges" ,preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }
        }
        
    }
    
    private func ParseJSON(){
        guard let path = Bundle.main.path(forResource: "List-Of-Emergency-Telephone-Numbers", ofType: "json") else {
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do{
            let jsonData = try Data(contentsOf: url)
            ememergencyNumbers = try JSONDecoder().decode(EmergencyNumbers.self, from: jsonData)
            return
        } catch{
            print("Error \(error)")
        }
    }
}

extension EmergencyViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let coordinate: CLLocationCoordinate2D = manager.location?.coordinate else{ return }
        coord = coordinate
        guard let location: CLLocation = manager.location else { return }
        
        print("location: \(coordinate.latitude) \(coordinate.longitude)")
        
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
