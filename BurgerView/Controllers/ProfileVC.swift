//
//  ProfileVC.swift
//  BurgerView
//
//  Created by Ben Davin on 2019-04-23.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UIImageView!
    @IBOutlet weak var numberOfBurgers: UILabel!
    @IBOutlet weak var reviewsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = 10
        
        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        
    }
    
    //MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewsTableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        
        return cell
    }
    
}
