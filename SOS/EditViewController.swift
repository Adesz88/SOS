//
//  EditViewController.swift
//  SOS
//
//  Created by Olej Ádám on 2022. 04. 30..
//

import UIKit
import CoreData

class EditViewController: UIViewController{
    
    
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
        loadUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SaveButton(_ sender: UIBarButtonItem) {
        if(!users.isEmpty) {
           editUser()
        } else {
            saveUser()
        }
        dismiss(animated: true)
        // TODO: SettingsViewController.loadUser()
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
            //birthDatePicker.date
            //bloodTypePicker
            diseasesTextView.text = users[0].value(forKeyPath: "diseases") as? String
            medicinesTextView.text = users[0].value(forKeyPath: "medicines") as? String
            SMSTextView.text = users[0].value(forKeyPath: "sms_text") as? String
            contactNameTextField.text = users[0].value(forKeyPath: "contact_name") as? String
            contactPhoneTextField.text = users[0].value(forKeyPath: "contact_phone") as? String
            
        }
    }
    
    func editUser() {
        users[0].setValue(nameTextField.text, forKey: "name")
        users[0].setValue(addressTextField.text, forKey: "address")
        users[0].setValue(Int(TAJTextField.text ?? "0"), forKey: "taj_number")
        users[0].setValue(birthPlaceTextField.text, forKey: "birth_place")
        users[0].setValue(birthDatePicker.date, forKey: "birth_date")
        //users[0].setValue(bloodTypePicker.text, forKey: "blood_type")
        users[0].setValue(diseasesTextView.text, forKey: "diseases")
        users[0].setValue(medicinesTextView.text, forKey: "medicines")
        users[0].setValue(SMSTextView.text, forKey: "sms_text")
        users[0].setValue(contactNameTextField.text, forKey: "contact_name")
        users[0].setValue(contactPhoneTextField.text, forKey: "contact_phone")
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func saveUser() {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let user = NSManagedObject(entity: entity!, insertInto: context)
        //TODO: mentés
        
        user.setValue(nameTextField.text, forKey: "name")
        user.setValue(addressTextField.text, forKey: "address")
        user.setValue(Int(TAJTextField.text ?? "0"), forKey: "taj_number")
        user.setValue(birthPlaceTextField.text, forKey: "birth_place")
        //user.setValue(birthDatePicker, forKey: "birth_date")
        //user.setValue(bloodTypePicker.text, forKey: "blood_type")
        user.setValue(diseasesTextView.text, forKey: "diseases")
        user.setValue(medicinesTextView.text, forKey: "medicines")
        user.setValue(SMSTextView.text, forKey: "sms_text")
        user.setValue(contactNameTextField.text, forKey: "contact_name")
        user.setValue(contactPhoneTextField.text, forKey: "contact_phone")
        do {
            try context.save()
        } catch let error {
            print(error)
        }
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
