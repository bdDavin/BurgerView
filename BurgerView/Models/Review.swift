//
//  Review.swift
//  BurgerView
//
//  Created by Ben Davin on 2019-04-23.
//  Copyright © 2019 Ben Davin. All rights reserved.
//

import Foundation

class Review {
    var user = ""
    var burgerJointName = ""
    var burgerName = ""
    var description = ""
    var rating = 0.0
    var imagePath = ""
    
    init(data:[String:Any]) {
        if let user = data["user"] as? String {
            self.user = user
        }
        if let burgerJointName = data["burgerJointName"] as? String {
            self.burgerJointName = burgerJointName
        }
        if let burgerName = data["burgerName"] as? String {
            self.burgerName = burgerName
        }
        if let description = data["description"] as? String {
            self.description = description
        }
        if let rating = data["rating"] as? Double {
            self.rating = rating
        }
        if let imagePath = data["imagePath"] as? String {
            self.imagePath = imagePath
        }
    }
    
    func data() -> [String:Any] {
        var data = [String:Any]()
        data["user"] = user
        data["burgerJointName"] = burgerJointName
        data["burgerName"] = burgerName
        data["description"] = description
        data["rating"] = rating
        data["imagePath"] = imagePath
        return data
    }
    
}
