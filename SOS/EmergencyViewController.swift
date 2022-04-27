//
//  ViewController.swift
//  SOS
//
//  Created by Olej Ádám on 2022. 04. 26..
//

import UIKit

class EmergencyViewController: UIViewController {
    
    @IBOutlet var Input: UITextField!
    
    @IBOutlet var Label: UILabel!
    
    var ememergencyNumbers: EmergencyNumbers?

    override func viewDidLoad() {
        super.viewDidLoad()
        ParseJSON()
        print((ememergencyNumbers?.numbers[0].Police.All.first)!!)
    }
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        for number in (ememergencyNumbers?.numbers)! {
            if (number.Country.ISOCode == Input.text){
                Label.text = number.Police.All.first!!
            }
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
            
            if let result = ememergencyNumbers{
                //print(result)
            } else{
                print("Failed to parse")
            }
            return
        } catch{
            print("Error \(error)")
        }
    }


}
