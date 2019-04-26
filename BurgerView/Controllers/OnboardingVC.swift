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

var spinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        spinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            spinner?.removeFromSuperview()
            spinner = nil
        }
    }
}
