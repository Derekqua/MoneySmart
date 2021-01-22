//
//  HistoryTableViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 21/1/21.
//

import Foundation
import UIKit

class HistoryTableViewController:UITableViewController{
    
    
    let controller = TransactionController()
    var tList:[Transaction] = []
    
    @IBOutlet weak var historytableView: UITableView!
    @IBOutlet var noItemView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        historytableView.register(nib, forCellReuseIdentifier: "HomeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        
    }
    

    //fetching data
    func fetchData() {
        if let s = controller.FetchTransactionData(){
            tList = s
            DispatchQueue.main.async {
                self.historytableView.reloadData()
            }
        }
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        //fetch data
        fetchData()
        tableView.tableFooterView = UIView()
        if tList.isEmpty{
            
            tableView.backgroundView = noItemView
        }
        else{
            tableView.backgroundView = UIView()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tList = controller.FetchTransactionData()!
        return tList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath ) as! HomeTableViewCell
            
            tList = controller.FetchTransactionData()!
            tList.reverse() //To show latest transaction on top
            let tObj = tList[indexPath.row]
            
            cell.catImageView?.image = tObj.image
            cell.title?.text = tObj.title
            cell.notes?.text = tObj.notes
            cell.price?.text = String(tObj.price)
            
            //Date formatting
            let dateFormatter = DateFormatter()
            let date:Date = tObj.datetime
             
            // British English Locale (en_GB)
            dateFormatter.locale = Locale(identifier: "en_GB")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // // set template after setting locale
            let newDate = dateFormatter.string(from: date) // 31 December
            
            cell.date?.text = newDate
            
            return cell
        
    }
    
    // when a table row is selected, the following delegate is called
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "TransactionDetailsViewController") as? TransactionDetailsViewController
        let obj = tList[indexPath.row]
        vc?.tImage = obj.image
        vc?.tNotes = obj.notes
        vc?.tTitle = obj.title
        vc?.tPrice = String(obj.price)
        vc?.type = obj.type
        
        //Date formatting
        let dateFormatter = DateFormatter()
        let date:Date = obj.datetime
         
        // British English Locale (en_GB)
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // // set template after setting locale
        let newDate = dateFormatter.string(from: date) // 31 December
        
        vc?.tDate = newDate
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
