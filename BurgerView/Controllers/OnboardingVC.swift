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

class IconButton: UIButton {
    override func didMoveToWindow() {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 5)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
    }
}

class PressButton: UIButton {
    override func didMoveToWindow() {
        self.layer.cornerRadius = layer.frame.height / 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 5)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.backgroundColor = #colorLiteral(red: 0.3803921569, green: 0.4352941176, blue: 0.2235294118, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 1, green: 0.8509803922, blue: 0.5568627451, alpha: 1), for: .normal)
    }
}

class CustomPicker: UIPickerView {
    override func didMoveToWindow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 5)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.75).cgColor]

        //self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
class TopView: UIView {
    override func didMoveToWindow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 5)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
    }
}

class CellView: UIView {
    override func didMoveToWindow() {
        self.layer.cornerRadius = 10
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 5)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
    }
}

class RoundedImageView: UIImageView {
    override func didMoveToWindow() {
        self.layer.cornerRadius = 10
    }
}
//Spinner
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
