//
//  UserReviewCell.swift
//  BurgerView
//
//  Created by Ben Davin on 2019-04-26.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit

class UserReviewCell: UITableViewCell {

    @IBOutlet weak var burgerJointNameLabel: UILabel!
    @IBOutlet weak var burgerNameLabel: UILabel!
    @IBOutlet weak var burgerImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
