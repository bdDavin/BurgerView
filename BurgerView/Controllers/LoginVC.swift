//
//  LoginVC.swift
//  Spot
//
//  Created by Ben Davin on 2019-04-12.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    //Buttons
    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        print("Going back")
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if !checkEmpty() {
            self.showSpinner(onView: view)
            auth.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { user, error in
                self.removeSpinner()
                if let err = error {
                    if err._code == AuthErrorCode.invalidEmail.rawValue {
                        self.errorLabel.text = "Invalid email address"
                    } else if err._code == AuthErrorCode.userNotFound.rawValue {
                        self.errorLabel.text = "Account dosent exist"
                    } else if err._code == AuthErrorCode.wrongPassword.rawValue {
                        self.errorLabel.text = "Wrong password"
                    } else {
                        self.errorLabel.text = "Something went wrong, please try again later"
                        print(err)
                    }
                    self.showError()
                    return
                }
                self.performSegue(withIdentifier: "goToMain", sender: nil)
            }
        }
    }
    //Checking for empty textfields
    func checkEmpty() -> Bool {
        hideError()
        if emailTextField.text == "" && passwordTextField.text == "" {
            UIView.animate(withDuration: 0.1, animations: {
                self.emailTextField.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.8)
                self.passwordTextField.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.8)
            }) { (done) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.emailTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.passwordTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                })
            }
            return true
        } else if emailTextField.text == "" {
            UIView.animate(withDuration: 0.1, animations: {
                self.emailTextField.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.8)
            }) { (done) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.emailTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                })
            }
            return true
        } else if passwordTextField.text == "" {
            UIView.animate(withDuration: 0.1, animations: {
                self.passwordTextField.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.8)
            }) { (done) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.passwordTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                })
            }
            return true
        }
        return false
    }
    //Funcs to change color
    func showError() {
        self.errorLabel.textColor = #colorLiteral(red: 1, green: 0.5137254902, blue: 0.3921568627, alpha: 1)
    }
    
    func hideError() {
        self.errorLabel.textColor = #colorLiteral(red: 0.3803921569, green: 0.4352941176, blue: 0.2235294118, alpha: 1)
    }
    //TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
