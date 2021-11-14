//
//  ThirdViewController.swift
//  Assignment4_Mario_Mendoza
//
//  Created by mario mendoza on 7/25/20.
//  Copyright © 2020 mario mendoza. All rights reserved.
//

import UIKit
/** Settings Class to display currenty user defaults
 User defaults are shared across all users unfortunalty*/
class ThirdViewController: UIViewController, UITextFieldDelegate {

    let defaults = UserDefaults.standard
    var users : UserDB!
    /**No first responders since user might want to just chekc out the settings before actually changing things*/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaultSpeed.delegate = self
        self.defaultDelay.delegate = self
        self.firstName.delegate = self
        self.lastName.delegate = self
        reload()
    }
    /**Called everytime this view is loaded into view
     retrieves user defaults stored throught program and sets them into the text boxes
     since user can omit last name, then check if user name can be seperated into first and last and then palce into respective text boxes
     */
    func reload(){
        defaultSpeed.text = String(defaults.value(forKey: "defaultSpeed") as! Double)
        let fullname = (defaults.value(forKey: "currentUser") as! String).components(separatedBy: " ")
        var first:String
        var last:String
        if fullname.count == 2{
            first = fullname[0]
            last = fullname[1]
        }else{
            first = fullname[0]
            last = ""
        }
        firstName.text = first
        lastName.text = last
        
        defaultDelay.text = String(defaults.value(forKey: "delay") as! Int)
    }
    
    @IBOutlet weak var defaultSpeed: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var defaultDelay: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    /**Action button to save changes made onto user defaults
     will check to see if changes made fit into their respective catagories like a speed should be a double or delay an int
     if not then will not change defaults
     since can change the name of the user, pass on the new user to the first controller */
    @IBAction func save(_ sender: Any) {
        if let speed = Double(defaultSpeed.text!){
            defaults.setValue(speed, forKey: "defaultSpeed")
        }
        if let delay = Int(defaultDelay.text!){
            defaults.setValue(delay, forKey: "delay")
        }
        let first = firstName.text!
        let last = lastName.text!
        let fullName = first + " " + last
        defaults.setValue(fullName, forKey: "currentUser")
        
        if users.count() != 0{
            users.getCurrentUser().setName(first, last)
        }
        let navContr = self.tabBarController?.viewControllers![0] as! UINavigationController
        (navContr.topViewController as! FirstViewController).users = users
    }
    /**When changing values, check to make sure first if valid entry, otherwise display error msg and dont let them exit text entry*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.defaultSpeed{
            if let num = Double(defaultSpeed.text!) {
                if num > 0 && num <= 600{
                    textField.resignFirstResponder()
                }else{
                    showAlert(title: "Error", msg: "You must enter a double between 1 and 600", handler: { action in self.defaultSpeed.becomeFirstResponder()})
                }
            }else{
                showAlert(title: "Error", msg: "You must enter a double between 1 and 600", handler: {action in self.defaultSpeed.becomeFirstResponder()})
            }
        }
        if textField == self.defaultDelay{
            if let num = Int(defaultDelay.text!){
                if num >= 0 && num < 10{
                    textField.resignFirstResponder()
                }else{
                    showAlert(title: "Error", msg: "You must enter an Integer between 0 and 10", handler: {action in self.defaultDelay.becomeFirstResponder()})
                }
            }else{
                showAlert(title: "Error", msg: "You must enter an Integer between 0 and 10", handler: {action in self.defaultDelay.becomeFirstResponder()})
            }
        }
        
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        defaultSpeed.resignFirstResponder()
        defaultDelay.resignFirstResponder()
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        
        if let num = Double(defaultSpeed.text!) {
            if num > 0 && num <= 600{
            }else{
                showAlert(title: "Error", msg: "You must enter a double between 1 and 600", handler:{ action in self.defaultSpeed.becomeFirstResponder()})
            }
        }else{
            showAlert(title: "Error", msg: "You must enter a double between 1 and 600", handler: {action in self.defaultSpeed.becomeFirstResponder()})
        }
        
        if let num1 = Int(defaultDelay.text!){
            if num1 >= 0 && num1 < 10{
            }else{
                showAlert(title: "Error", msg: "You must enter an Integer between 0 and 10", handler: {action in self.defaultDelay.becomeFirstResponder()})
            }
        }else{
            showAlert(title: "Error", msg: "You must enter an Integer between 0 and 10", handler: {action in self.defaultDelay.becomeFirstResponder()})
        }
    }
    
    func showAlert(title: String, msg: String, handler: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: handler)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    /**Retrieve users from first view controller and set it to this user
     reload all data once set */
    override func viewDidAppear(_ animated: Bool) {
        let navContr = self.tabBarController?.viewControllers![0] as! UINavigationController
        users = (navContr.topViewController as! FirstViewController).users
        reload()
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /**Clicking change user will segue into user list controller that displays all users
     set the UserDB of that controller to this one, and reload table data to update just in case
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier{
            switch id {
            case "changeUsers":
                if let UserListTVC = segue.destination as? UserListTableViewController{
                    UserListTVC.users = users
                    UserListTVC.tableView.reloadData()
                }
            default:
                break
            }
        }
    }
    

}
