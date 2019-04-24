//
//  CreatePasswordVC.swift
//  Spot
//
//  Created by Ben Davin on 2019-04-12.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase

class CreatePasswordVC: UIViewController {
    
    var firstName = ""
    var lastName = ""
    var email = ""
    
    let auth = Auth.auth()

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        let password = passwordTextField.text!
        
        auth.createUser(withEmail: email, password: password) { authResult, error in
            let changeRequest = self.auth.currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = "\(self.firstName) \(self.lastName)"
            changeRequest?.commitChanges { (error) in
                print(error.debugDescription)
            }
            self.performSegue(withIdentifier: "goToMain", sender: nil)
        }
    }
}
