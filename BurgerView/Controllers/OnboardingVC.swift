//
//  OnboardingVC.swift
//  Spot
//
//  Created by Ben Davin on 2019-04-12.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import Firebase

class OnboardingVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var onboardingScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingScrollView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        //Checking logged in state
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goToMap", sender: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("ScrollView did scroll")
        let pageNumber = Int(round(scrollView.contentOffset.x/view.frame.size.width))
        pageControl.currentPage = pageNumber
    }
    
    
}
