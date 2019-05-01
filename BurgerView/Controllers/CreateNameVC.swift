//
//  CreateNameVC.swift
//  Spot
//
//  Created by Ben Davin on 2019-04-12.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit

class CreateNameVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.becomeFirstResponder()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
    }
    
    //Buttons
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        print("Going back")
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        if !checkEmpty() {
            performSegue(withIdentifier: "goToEmail", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        
        let destVC = segue.destination as! CreateEmailVC
        
        destVC.firstName = firstName
        destVC.lastName = lastName

    }
    
    //Checking for empty textfields
    func checkEmpty() -> Bool {
        if firstNameTextField.text == "" && lastNameTextField.text == "" {
            UIView.animate(withDuration: 0.1, animations: {
                self.firstNameTextField.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.8)
                self.lastNameTextField.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.8)
            }) { (done) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.firstNameTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.lastNameTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                })
            }
            return true
        } else if firstNameTextField.text == "" {
            UIView.animate(withDuration: 0.1, animations: {
                self.firstNameTextField.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.8)
            }) { (done) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.firstNameTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                })
            }
            return true
        } else if lastNameTextField.text == "" {
            UIView.animate(withDuration: 0.1, animations: {
                self.lastNameTextField.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.8)
            }) { (done) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.lastNameTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                })
            }
            return true
        }
        return false
    }
    //TextFieldDeleagte
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
