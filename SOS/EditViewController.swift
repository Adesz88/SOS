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
    let bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "0+", "0-"]
    var users: [NSManagedObject] = []

    override func viewWillAppear(_ animated: Bool) {
        bloodTypePicker.dataSource = self
        bloodTypePicker.delegate = self
        loadUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(users.isEmpty) {
            let noUserAlert = UIAlertController(title: "Nincsenek adatok regisztrálva", message: "Az alkalmazás használatához kérlek töltsd ki az adatokat", preferredStyle: .alert)
            noUserAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(noUserAlert, animated: true)
        }
    }
    
    @IBAction func SaveButton(_ sender: UIBarButtonItem) {
        if (!nameTextField.text!.isEmpty && !addressTextField.text!.isEmpty && !TAJTextField.text!.isEmpty && !birthPlaceTextField.text!.isEmpty && !diseasesTextView.text!.isEmpty && !medicinesTextView.text!.isEmpty && !SMSTextView.text!.isEmpty && !contactNameTextField.text!.isEmpty && !contactPhoneTextField.text!.isEmpty) {
            if(!users.isEmpty) {
               editUser()
            } else {
                saveUser()
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let settingsVC: SettingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            dismiss(animated: true)
            //present(settingsVC, animated: false)
            // TODO: SettingsViewController.loadUser()
        } else {
            let emptyFields = UIAlertController(title: "Hiányzó adatok", message: "Az alkalmazás használatához kérlek töltsd ki az összes mezőt", preferredStyle: .alert)
            emptyFields.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(emptyFields, animated: true)
        }
    }
    
    func loadUser() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            users = try context.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        
        if (!users.isEmpty) {
            nameTextField.text = users[0].value(forKeyPath: "name") as? String
            addressTextField.text = users[0].value(forKeyPath: "address") as? String
            TAJTextField.text = String((users[0].value(forKey: "taj_number") as? Int32 ?? 0))
            birthPlaceTextField.text = users[0].value(forKeyPath: "birth_place") as? String
            birthDatePicker.date = users[0].value(forKeyPath: "birth_date") as? Date ?? Date.now
            
            var index = 0
            for i in 0..<bloodTypes.count{
                if (bloodTypes[i].contains((users[0].value(forKeyPath: "blood_type") as? String)!)){
                    index = i
                    break
                }
            }
            bloodTypePicker.selectRow(index, inComponent: 0, animated: false)
            
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
        users[0].setValue(bloodTypes[bloodTypePicker.selectedRow(inComponent: 0)], forKey: "blood_type")
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
        user.setValue(birthDatePicker.date, forKey: "birth_date")
        users[0].setValue(bloodTypes[bloodTypePicker.selectedRow(inComponent: 0)], forKey: "blood_type")
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
}

extension EditViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bloodTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bloodTypes[row]
    }
}
