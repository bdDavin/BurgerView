//
//  CreateReviewVC.swift
//  BurgerView
//
//  Created by Ben Davin on 2019-04-24.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class CreateReviewVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var burgerPickerView: UIPickerView!
    @IBOutlet weak var burgerImageView: UIImageView!
    @IBOutlet weak var burgerNameInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var starRatingView: CosmosView!
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var burgerJoint = MKMapItem()
    var burgers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        starRatingView.settings.fillMode = .half
        starRatingView.rating = 0
        
        setupPicker()
    }

    @IBAction func publishPressed(_ sender: UIButton) {
        
        guard let name = auth.currentUser?.displayName else {
            return
        }
        
        let reviewData = ["user": name,
                          "burgerName": burgerNameInput.text!,
                          "description": descriptionInput.text!,
                          "rating": starRatingView.rating,
                          "image": false] as [String : Any]
        
        db.collection(burgerJoint.name!).addDocument(data: reviewData)
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - PickerView
    
    func setupPicker(){
        burgerPickerView.delegate = self
        burgerPickerView.dataSource = self
        
        db.collection(burgerJoint.name!).getDocuments { (snapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    let review = Review(data: data)
                    print(review.burgerName)
                    if !self.burgers.contains(review.burgerName) {
                        self.burgers.append(review.burgerName)
                    }
                }
            }
            self.burgerPickerView.reloadAllComponents()
        }
        burgerPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return burgers.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 {
            return "Create new burger"
        }else {
            return burgers[row - 1]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            burgerNameInput.isEnabled = true
            burgerNameInput.text = ""
        } else {
            burgerNameInput.isEnabled = false
            burgerNameInput.text = burgers[row - 1]
        }
    }
    
}
