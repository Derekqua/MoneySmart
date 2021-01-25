//
//  TransactionDetailsViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 21/1/21.
//

import Foundation
import UIKit

class TransactionDetailsViewController: UIViewController {

    let controller = TransactionController()
    
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
    @IBAction func deleteBtn(_ sender: Any) {
        controller.DeleteTransaction(id: tid)
        //return back to Home viewController
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editBtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "EditTransactionViewController") as? EditTransactionViewController
        vc?.tid = Int32(tid)!
        vc?.tImage = tImage
        vc?.tNotes = tNotes
        vc?.tTitle = tTitle
        vc?.tPrice = Double(dblPrice)!
        vc?.type = type
        //vc?.tDate = obj.datetime
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    var tid = ""
    var tImage = UIImage()
    var tNotes = ""
    var tTitle = ""
    var tPrice = ""
    var tDate = ""
    var type = ""
    var dblPrice = ""
    
    
}
