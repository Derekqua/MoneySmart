//
//  Transaction.swift
//  MoneySmart
//
//  Created by Derek Qua on 19/1/21.
//

import Foundation
import UIKit

class Transaction {
    
    var image: UIImage
    var title: String
    var name: String
    var price: Double
    var datetime:Date
    
    init(image:UIImage, title:String, name:String, price:Double, datetime:Date) {
        self.image = image
        self.title = title
        self.name = name
        self.price = price
        self.datetime = datetime
    }
    
}
