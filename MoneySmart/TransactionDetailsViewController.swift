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
    
    override func viewDidAppear(_ animated: Bool) {
        //get data then refresh page
        let t1:Transaction = controller.GetTransaction(id: tid)
        
        titleTxt.text = t1.title
        catImage.image = t1.image
        tType.text = t1.type
        nameTxt.text = t1.notes
        
        if t1.type == "Income"{
            tPrice = "+" + String(format: "%.2f",t1.price) + " SGD"
        }
        else{
            tPrice = "-" + String(format: "%.2f",t1.price) + " SGD"
        }
        priceTxt.text = tPrice
        
        //Date formatting
        let dateFormatter = DateFormatter()
        let date:Date = t1.datetime
         
        // British English Locale (en_GB)
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // // set template after setting locale
        let newDate = dateFormatter.string(from: date) // 31 December
        
        dateTxt.text = newDate
        
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
        vc?.realDate = realDate
        
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
    var realDate = Date()
    
    
}
