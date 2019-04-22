//
//  CreateNameVC.swift
//  Spot
//
//  Created by Ben Davin on 2019-04-12.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit

class CreateNameVC: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        print("Going back")
        self.dismiss(animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        
        let destVC = segue.destination as! CreateEmailVC
        
        destVC.firstName = firstName
        destVC.lastName = lastName
    }
    
}
