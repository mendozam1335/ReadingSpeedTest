//
//  LoginViewController.swift
//  Assignment4_Mario_Mendoza
//
//  Created by mario mendoza on 7/25/20.
//  Copyright © 2020 mario mendoza. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    var user: User!
    var currentUser : String = ""
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstName.delegate = self
        self.lastName.delegate = self
    }
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.firstName {
            textField.resignFirstResponder()
            self.lastName.becomeFirstResponder()
        }
        if textField == self.lastName {
            textField.resignFirstResponder()
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /** Create a new User based on first and last name
     Ok for user to not input either first or last name but not both*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        user = User(firstName: firstName.text!, lastName: lastName.text!)
        if segue.identifier == "addNewUser"{
            dismiss(animated: true, completion: nil)
            //self.navigationController?.popToRootViewController(animated: true)
        }
    }


}
