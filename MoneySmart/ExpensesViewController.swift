//
//  ExpensesViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 20/1/21.
//

import Foundation
import UIKit

class ExpensesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var textArray = ["Clothing", "Entertainment", "Food", "Utilities", "Transport", "Uncategorized"]
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/6, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.catImage2.image = UIImage(named: textArray[indexPath.row])
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.backgroundColor = UIColor.white.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        categoryField.text = textArray[indexPath.row]
    }
    

    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var notestxt: UITextField!
    @IBOutlet weak var pricetxt: UITextField!
    
    @IBAction func cancelbtn(_ sender: Any) {
        //return back to Home viewController
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitbtn(_ sender: Any)
    {
        //check if textfield empty
        if pricetxt.text!.isEmpty || notestxt.text!.isEmpty || categoryField.text!.isEmpty{
            alert("Please fill up the following details")
        }
        else{
            
            let price = Double(pricetxt.text!)
            
            //check if price is digit not string
            if price == nil{
                alert("Invalid Price, Please Try Again")
                pricetxt.text = ""
                
            }
            else{
                //Creating Transaction Object & add into core data
                let controller = TransactionController()
                let id = controller.GetLatestTransactionId()
                let transaction = Transaction(id: id, image: UIImage(named: categoryField.text!)! , title: categoryField.text! , notes: notestxt.text!, price: price!, datetime: Date(), type: "Expenses")
                
                controller.AddTransactionData(t: transaction)
                
                //return back to Home viewController
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }
       
        
        
    }
    
    //Alert message
    func alert(_ message:String){
            print("Alert: \(message)")
            let alert = UIAlertController(title: "Empty field", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default){_ in
                self.dismiss(animated: true, completion: nil)
            })
            
            self.present(alert, animated: true, completion: nil)
            
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.notestxt.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }

  
}

