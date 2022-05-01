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
    @IBOutlet weak var TAJTextField: UITextField!
    @IBOutlet weak var birthPlaceTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    @IBOutlet weak var bloodTypePicker: UIPickerView!
    @IBOutlet weak var diseasesTextView: UITextView!
    @IBOutlet weak var medicinesTextView: UITextView!
    @IBOutlet weak var SMSTextView: UITextView!
    @IBOutlet weak var relativeNameTextField: UITextField!
    @IBOutlet weak var relativePhoneTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var users: [NSManagedObject] = []

    @IBAction func SaveButton(_ sender: UIBarButtonItem) {
        saveUser()
        print("szoveg")
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadUser(){
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            users = try context.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        
        //nameTextField.text = users[0].value(forKeyPath: "name") as? String
        //TAJTextField.text = users[0].value(forKey: "taj_number") as? String
    }
    
    func editUser(){
        
        users[0].setValue("user", forKey: "name")
        
        do {
            try context.save()
            loadUser()
        } catch let error {
            print(error)
        }
    }
    
    func saveUser(){
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        
        let user = NSManagedObject(entity: entity!, insertInto: context)
        //TODO: mentés
        user.setValue("Test user", forKey: "name")
        user.setValue(123456789, forKey: "taj_number")
        
        do {
            try context.save()
            loadUser()
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
