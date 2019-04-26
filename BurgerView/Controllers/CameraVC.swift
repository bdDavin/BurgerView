//
//  CameraVC.swift
//  BurgerView
//
//  Created by Ben Davin on 2019-04-24.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import UIKit
import CameraManager

protocol CameraDelegate {
    func didTakePicture(image:UIImage)
}

class CameraVC: UIViewController {
    
    var cameraDelegate: CameraDelegate?
    let camera = CameraManager()
    var myImage = UIImage()

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var rotateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup
        camera.addPreviewLayerToView(cameraView)
        camera.cameraDevice = .back
        camera.writeFilesToPhoneLibrary = false
        
    }
    
    @IBAction func rotatePressed(_ sender: UIButton) {
        if camera.cameraDevice == .back {
            camera.cameraDevice = .front
        } else {
            camera.cameraDevice = .back
        }
    }
    
    @IBAction func capturePressed(_ sender: UIButton) {
        camera.capturePictureWithCompletion { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let content):
                self.myImage = content.asImage!
                
                self.dismiss(animated: true, completion: {
                    self.cameraDelegate?.didTakePicture(image: self.myImage)
                })
            }
        }
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
