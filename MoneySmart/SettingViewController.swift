//
//  SettingViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 19/1/21.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {

    let controller = TransactionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clearBtn(_ sender: Any) {
        controller.DeleteAllTransaction()
        alert("Data has been cleared")
    }
    
    
    //Alert message
    func alert(_ message:String){
            print("Alert: \(message)")
            let alert = UIAlertController(title: "Clear Data", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default){_ in
                self.dismiss(animated: true, completion: nil)
            })
            
            self.present(alert, animated: true, completion: nil)
            
        }
}
