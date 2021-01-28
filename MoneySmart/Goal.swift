//
//  Goal.swift
//  MoneySmart
//
//  Created by brandon on 27/1/21.
//

import Foundation
import UIKit

class Goal {
    
    var id : Int32
    var image: UIImage
    var goal: String
    var price: Double
    var deadline:Date
    var title:String
    
    
    init(id:Int32, image:UIImage, goal:String, price:Double, deadline:Date, title:String) {
        self.id = id
        self.image = image
        self.goal = goal
        self.price = price
        self.deadline = deadline
        self.title = title
      
    }
    
}
