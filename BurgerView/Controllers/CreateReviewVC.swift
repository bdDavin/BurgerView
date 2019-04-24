//
//  CreateReviewVC.swift
//  BurgerView
//
//  Created by Ben Davin on 2019-04-24.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit

class CreateReviewVC: UIViewController {

    @IBOutlet weak var burgerImageView: UIImageView!
    @IBOutlet weak var burgerNameInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var starRatingView: CosmosView!
    override func viewDidLoad() {
        super.viewDidLoad()

        starRatingView.settings.fillMode = .half
        starRatingView.rating = 1.5
    }

    @IBAction func publishPressed(_ sender: UIButton) {
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
    }
}
