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
import CameraManager

class CreateReviewVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CameraDelegate {
    
    @IBOutlet weak var burgerPickerView: UIPickerView!
    @IBOutlet weak var burgerImageView: UIImageView!
    @IBOutlet weak var burgerNameInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var starRatingView: CosmosView!
    
    let auth = Auth.auth()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    var burgerJoint = MKMapItem()
    var burgers = [String]()
    var picturePath = ""
    var didTakePicture = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup
        starRatingView.settings.fillMode = .half
        starRatingView.rating = 0
        
        setupPicker()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! CameraVC
        destVC.cameraDelegate = self
    }

    //MARK: - Buttons
    
    @IBAction func publishPressed(_ sender: UIButton) {
        
        if didTakePicture {
            //kompresses data
            guard let data = burgerImageView.image?.jpegData(compressionQuality: 0.25) else {
                print("something went wrong")
                return
            }
            //gets a unique id
            let id = UUID()
            let ref = storage.child("burgerImages/\(id).jpeg")
            //Uploads the data to firbase storage
            self.showSpinner(onView: view)
            let task = ref.putData(data, metadata: nil) { (metadata, error) in
                print("Upload started")
                ref.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print(error.debugDescription)
                        return
                    }
                    self.picturePath = downloadURL.absoluteString
                    
                    guard let name = self.auth.currentUser?.displayName else {
                        return
                    }
                    //Put the review info in a dictionary adn writes it to Firestore database
                    let reviewData = ["user": name,
                                      "burgerName": self.burgerNameInput.text!,
                                      "description": self.descriptionInput.text!,
                                      "rating": self.starRatingView.rating,
                                      "imagePath": self.picturePath] as [String : Any]
                    self.db.collection(self.burgerJoint.name!).addDocument(data: reviewData)
                }
            }
            task.observe(.success) { (snapshot) in
                self.removeSpinner()
                self.dismiss(animated: true, completion: nil)
            }
        }else {
            guard let name = self.auth.currentUser?.displayName else {
                return
            }
            let reviewData = ["user": name,
                              "burgerName": self.burgerNameInput.text!,
                              "description": self.descriptionInput.text!,
                              "rating": self.starRatingView.rating,
                              "imagePath": self.picturePath] as [String : Any]
            db.collection(self.burgerJoint.name!).addDocument(data: reviewData)
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Camera
    
    @IBAction func startCamera(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "goToCamera", sender: nil)
    }
    
    func didTakePicture(image: UIImage) {
        didTakePicture = true
        burgerImageView.image = image
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
                self.burgers.sort()
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
