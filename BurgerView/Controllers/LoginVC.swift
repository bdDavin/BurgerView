//
//  LoginVC.swift
//  Spot
//
//  Created by Ben Davin on 2019-04-12.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        print("Going back")
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Måste fylla i allt")
            return
        }
        
        auth.signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                print(error)
                return
            }
            self.performSegue(withIdentifier: "goToMain", sender: nil)
        }
    }
}
