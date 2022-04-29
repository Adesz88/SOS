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
    @IBOutlet weak var TAJTextField: UITextField!
    
    var users: [NSManagedObject] = []

    override func viewWillAppear(_ animated: Bool) {
        saveUser()
        loadUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        editUser()
    }
    
    func loadUser(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            users = try managedContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        
        nameTextField.text = users[0].value(forKeyPath: "name") as? String
        TAJTextField.text = users[0].value(forKey: "taj_number") as? String
    }
    
    func saveUser(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        
        let user = NSManagedObject(entity: entity!, insertInto: managedContext)
        //TODO: mentés
        user.setValue("Test user", forKey: "name")
        user.setValue(123456789, forKey: "taj_number")
        
        do {
            try managedContext.save()
            loadUser()
        } catch let error {
            print(error)
        }
    }
    
    func editUser(){
        
    }
    
    /*TODO: edit user
     Updating an object in CoreData is quite similar to creating a new one. First you have to fetch your object from CoreData using a /fetchRequest/. After that you can edit the fetched object and update it's attributes. After that, just save it back using the /managedObjectContext/.
     */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
