//
//  TransactionDetailsViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 21/1/21.
//

import Foundation
import UIKit

class TransactionDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        titleTxt.text = tTitle
        catImage.image = tImage
        tType.text = type
        priceTxt.text = tPrice
        dateTxt.text = tDate
        nameTxt.text = tNotes
        
    }


    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var tType: UILabel!
    @IBOutlet weak var priceTxt: UILabel!
    @IBOutlet weak var dateTxt: UILabel!
    @IBOutlet weak var nameTxt: UILabel!
    
    var tImage = UIImage()
    var tNotes = ""
    var tTitle = ""
    var tPrice = ""
    var tDate = ""
    var type = ""
    
    
}
