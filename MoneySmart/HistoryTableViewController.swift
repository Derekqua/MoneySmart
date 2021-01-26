//
//  HistoryTableViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 21/1/21.
//

import Foundation
import UIKit

class HistoryTableViewController:UITableViewController, UISearchBarDelegate{
    
    
    let controller = TransactionController()
    var tList:[Transaction] = []
    var filterData:[Transaction] = []
    
    @IBOutlet weak var historytableView: UITableView!
    @IBOutlet var noItemView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Search bar
        searchBar.delegate = self
        
        //register cell
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        historytableView.register(nib, forCellReuseIdentifier: "HomeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
        
    }
    

    //fetching data
    func fetchData() {
        filterData = [] //empty list before feteching data
        if let s = controller.FetchTransactionData(){
            filterData = s
            filterData.reverse()
            DispatchQueue.main.async {
                self.historytableView.reloadData()
            }
        }
    }
    
    // Called when search bar obtains focus.  I.e., user taps
    // on the search bar to enter text.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false

        // Remove focus from the search bar.
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = []
        tList = controller.FetchTransactionData()!
        
        if searchText.isEmpty{
            filterData = tList
            filterData.reverse()
        }
        else{
            for i in tList{
                //price formatting
                var price:String
                if i.type == "Income"{
                    price = "+" + String(format: "%.2f",i.price) + " SGD"
                }
                else{
                    price = "-" + String(format: "%.2f",i.price) + " SGD"
                }
                
                //Date formatting
                let dateFormatter = DateFormatter()
                let date:Date = i.datetime
                 
                // British English Locale (en_GB)
                dateFormatter.locale = Locale(identifier: "en_GB")
                dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // // set template after setting locale
                let newDate = dateFormatter.string(from: date) // 31 December
                
                //filtering by title, notes, price and datetime
                if i.title.lowercased().contains(searchText.lowercased()) || price.lowercased().contains(searchText.lowercased()) || i.notes.lowercased().contains(searchText.lowercased()) || newDate.lowercased().contains(searchText.lowercased()){
                    
                    filterData.append(i)
                }
                
            }
        }
        self.tableView.reloadData()
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        //fetch data
        fetchData()
        tableView.tableFooterView = UIView()
        if filterData.isEmpty{
            searchBar.isHidden = true
            tableView.backgroundView = noItemView
        }
        else{
            searchBar.isHidden = false
            tableView.backgroundView = UIView()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tList = controller.FetchTransactionData()!
        return filterData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath ) as! HomeTableViewCell

            let tObj = filterData[indexPath.row]
            
            cell.catImageView?.image = tObj.image
            cell.title?.text = tObj.title
            cell.notes?.text = tObj.notes
        
            if tObj.type == "Income"{
                cell.price?.text = "+" + String(format: "%.2f",tObj.price) + " SGD"
            }
            else{
                cell.price?.text = "-" + String(format: "%.2f",tObj.price) + " SGD"
            }
            
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
        let obj = filterData[indexPath.row]
        vc?.tid = String(obj.id)
        vc?.tImage = obj.image
        vc?.tNotes = obj.notes
        vc?.tTitle = obj.title
        vc?.dblPrice = String(obj.price) //string price without formatting
        if obj.type == "Income"{
            vc?.tPrice = "+" + String(format: "%.2f",obj.price) + " SGD"
        }
        else{
            vc?.tPrice = "-" + String(format: "%.2f",obj.price) + " SGD"
        }
        vc?.type = obj.type
        
        //Date formatting
        let dateFormatter = DateFormatter()
        let date:Date = obj.datetime
         
        // British English Locale (en_GB)
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // // set template after setting locale
        let newDate = dateFormatter.string(from: date) // 31 December
        
        vc?.tDate = newDate
        vc?.realDate = obj.datetime
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, sourceView, completionHandler) in completionHandler(true)
            
            //deleting object
            let obj = self.filterData[indexPath.row]
            controller.DeleteTransaction(id: String(obj.id))
            filterData.remove(at: indexPath.row)
            self.tableView.reloadData()
        }

        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in completionHandler(true)
            
            let vc = self.storyboard?.instantiateViewController(identifier: "EditTransactionViewController") as? EditTransactionViewController
            let obj = self.filterData[indexPath.row]
            vc?.tid = obj.id
            vc?.tImage = obj.image
            vc?.tNotes = obj.notes
            vc?.tTitle = obj.title
            vc?.tPrice = obj.price
            vc?.type = obj.type
            vc?.realDate = obj.datetime
            
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        edit.backgroundColor = UIColor.blue
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete, edit])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
}
