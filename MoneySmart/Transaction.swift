//
//  Transaction.swift
//  MoneySmart
//
//  Created by Derek Qua on 19/1/21.
//

import Foundation
import UIKit

class Transaction {
    
    var id : Int32
    var image: UIImage
    var title: String
    var notes: String
    var price: Double
    var datetime:Date
    var type: String
    
    init(id:Int32, image:UIImage, title:String, notes:String, price:Double, datetime:Date, type:String) {
        self.id = id
        self.image = image
        self.title = title
        self.notes = notes
        self.price = price
        self.datetime = datetime
        self.type = type
    }
    
}
