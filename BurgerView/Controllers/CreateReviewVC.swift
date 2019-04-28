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

class CreateReviewVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, ImagePickerDelegate {
    
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
        descriptionInput.delegate = self
        descriptionInput.text = "Descibe the taste"
        descriptionInput.textColor = UIColor.lightGray
        
        starRatingView.settings.fillMode = .half
        starRatingView.rating = 0
        
        imagePicker = ImagePicker(presentationController: self, delegate: self)
                
        setupPicker()
    }
    
    //MARK: - TextView
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionInput.textColor == UIColor.lightGray {
            descriptionInput.text = nil
            descriptionInput.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionInput.text.isEmpty {
            descriptionInput.text = "Descibe the taste"
            descriptionInput.textColor = UIColor.lightGray
        }
    }

    //MARK: - Buttons
    
    @IBAction func publishPressed(_ sender: UIButton) {
        
        self.showSpinner(onView: view)
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
                                      "burgerJointName": self.burgerJoint.name!,
                                      "burgerName": self.burgerNameInput.text!,
                                      "description": self.descriptionInput.text!,
                                      "rating": self.starRatingView.rating,
                                      "imagePath": self.picturePath] as [String : Any]
                    self.db.collection("Reviews").addDocument(data: reviewData)
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
                              "burgerJointName": self.burgerJoint.name!,
                              "burgerName": self.burgerNameInput.text!,
                              "description": self.descriptionInput.text!,
                              "rating": self.starRatingView.rating,
                              "imagePath": self.picturePath] as [String : Any]
            self.db.collection("Reviews").addDocument(data: reviewData, completion: { (err) in
                if let err = err {
                    print(err.localizedDescription)
                }else {
                }
                self.removeSpinner()
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Camera
    
    var imagePicker: ImagePicker!
    
    func didSelect(image: UIImage?) {
        didTakePicture = true
        guard let nonNilImage = image else {
            return
        }
        burgerImageView.image = nonNilImage
    }
    
    @IBAction func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    //MARK: - PickerView
    
    func setupPicker(){
        burgerPickerView.delegate = self
        burgerPickerView.dataSource = self
        
        db.collection("Reviews").getDocuments { (snapshot, error) in
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
