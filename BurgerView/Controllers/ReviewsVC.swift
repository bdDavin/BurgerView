//
//  ReviewsVC.swift
//  BurgerView
//
//  Created by Ben Davin on 2019-04-23.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class ReviewsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var burgerJointNameLabel: UILabel!
    @IBOutlet weak var filterPickerView: UIPickerView!
    @IBOutlet weak var reviewsTableView: UITableView!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var burgerItem = MKMapItem()
    var menuItems = [String]()
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup
        burgerJointNameLabel.text = burgerItem.name
        
        filterPickerView.delegate = self
        filterPickerView.dataSource = self
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        showSpinner(onView: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getDataFor(burger: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! CreateReviewVC
        destVC.burgerJoint = burgerItem
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Data
    
    func getDataFor(burger: String) {
        db.collection("Reviews").whereField("burgerJointName", isEqualTo: burgerItem.name!).addSnapshotListener { (snapshot, error) in
            if let err = error {
                print("Error getting documents: \(err)")
            } else {
                self.reviews.removeAll()
                for document in snapshot!.documents {
                    let data = document.data()
                    let review = Review(data: data)
                    if burger != "" {
                        if review.burgerName == burger {
                            self.reviews.append(review)
                        }
                    }else {
                        self.reviews.append(review)
                        self.setupPicker()
                    }
                }
                self.reviewsTableView.reloadData()
                self.removeSpinner()
            }
        }
    }
    
    //MARK: - PickerView
    
    func setupPicker(){
        menuItems.removeAll()
        for review in reviews {
            if !menuItems.contains(review.burgerName) {
                menuItems.append(review.burgerName)
            }
        }

        menuItems.sort()
        filterPickerView.reloadAllComponents()
        filterPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return menuItems.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "All burgers"
        }else {
            return menuItems[row - 1]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0 {
            getDataFor(burger: menuItems[row - 1])
        }else {
            getDataFor(burger: "")
        }
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 0 {
            let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
            let review = reviews[indexPath.row - 1]
            cell.burgerNameLabel.text = review.burgerName
            //Getting images
            if review.imagePath != "" {
                let ref = storage.reference(forURL: review.imagePath)
                ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        DispatchQueue.main.async {
                            cell.burgerImageView.image = UIImage(data: data!)
                        }
                    }
                }
            }
            
            cell.reviewedByLabel.text = "Review by: \(review.user)"
            cell.descLabel.text = review.description
            cell.ratingView.rating = Double(review.rating)
            return cell
        } else {
            let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "TotalReviewsCell", for: indexPath) as! TotalReviewsCell
            cell.totalReviewsLAbel.text = "Reviews: \(reviews.count)"
            return cell
        }
    }
}
