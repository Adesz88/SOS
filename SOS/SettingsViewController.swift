//
//  SettingsViewController.swift
//  SOS
//
//  Created by Olej Ádám on 2022. 04. 27..
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var TAJTextField: UITextField!
    @IBOutlet weak var birthPlaceTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var bloodTypePicker: UIPickerView!
    @IBOutlet weak var diseasesTextView: UITextView!
    @IBOutlet weak var medicinesTextView: UITextView!
    @IBOutlet weak var SMSTextView: UITextView!
    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var contactPhoneTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var users: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        print("settings viewWillAppear")
        loadUser()
        if(!users.isEmpty){
            print(users)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("settings viewDidLoad")
        // Do any additional setup after loading the view.
        //loadUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("settings viewDidAppear")
        
    }
    
    @IBAction func DeleteButtonPressed(_ sender: UIButton) {
        deleteUser()
    }
    
    func loadUser() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            users = try context.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        
        if(!users.isEmpty) {
            nameTextField.text = users[0].value(forKeyPath: "name") as? String
            addressTextField.text = users[0].value(forKeyPath: "address") as? String
            TAJTextField.text = String((users[0].value(forKey: "taj_number") as? Int32 ?? 0))
            birthPlaceTextField.text = users[0].value(forKeyPath: "birth_place") as? String
            birthDatePicker.date = users[0].value(forKeyPath: "birth_date") as? Date ?? Date.now
            //bloodTypePicker
            diseasesTextView.text = users[0].value(forKeyPath: "diseases") as? String
            medicinesTextView.text = users[0].value(forKeyPath: "medicines") as? String
            SMSTextView.text = users[0].value(forKeyPath: "sms_text") as? String
            contactNameTextField.text = users[0].value(forKeyPath: "contact_name") as? String
            contactPhoneTextField.text = users[0].value(forKeyPath: "contact_phone") as? String
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let editVC = storyboard.instantiateViewController(withIdentifier: "EditViewController")
            show(editVC, sender: self)
        }
    }
    
    func deleteUser() {
        for userItem in users {
            context.delete(userItem)
        }
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
        loadUser()
    }
    
    func reload(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        present(editVC, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
