//
//  CreateEmailVC.swift
//  Spot
//
//  Created by Ben Davin on 2019-04-12.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit

class CreateEmailVC: UIViewController {
    
    var firstName = ""
    var lastName = ""

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let email = emailTextField.text!
        
        let destVC = segue.destination as! CreatePasswordVC
        
        destVC.firstName = firstName
        destVC.lastName = lastName
        destVC.email = email
    }
}
