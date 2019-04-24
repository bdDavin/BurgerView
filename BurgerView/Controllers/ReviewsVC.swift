//
//  ReviewsVC.swift
//  BurgerView
//
//  Created by Ben Davin on 2019-04-23.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import MapKit

class ReviewsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var burgerJointNameLabel: UILabel!
    @IBOutlet weak var filterPickerView: UIPickerView!
    @IBOutlet weak var reviewsTableView: UITableView!
    
    var burgerItem = MKMapItem()
    var menuItems = [String]()
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate
        filterPickerView.delegate = self
        filterPickerView.dataSource = self
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
        burgerJointNameLabel.text = burgerItem.name

        
        //test items
        for int in 1...10 {
            menuItems.append("\(int)")
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
    }
    
    //MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return menuItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return menuItems[row]
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3//reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        
        return cell
    }
}
