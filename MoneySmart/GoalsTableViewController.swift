//
//  GoalsViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 19/1/21.
//

import Foundation
import UIKit

class GoalsTableViewController: UITableViewController {

    let controller = GoalController()
    var tList:[Goal] = []
    var filterData:[Goal] = []
    
    @IBOutlet weak var uselessText: UILabel!
    @IBOutlet weak var historytableView: UITableView!
    @IBOutlet weak var goalneeded: UILabel!
    @IBOutlet var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Search bar
                
        //register cell
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        historytableView.register(nib, forCellReuseIdentifier: "HomeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        goalneeded.text = fetchamt()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        goalneeded.text = fetchamt()
        fetchData()
        tableView.tableFooterView = UIView()
        if filterData.isEmpty{
            tableView.backgroundView = emptyView
            uselessText.isHidden = true
            goalneeded.isHidden = true
        }
        else{
            tableView.backgroundView = UIView()
            uselessText.isHidden = false
            goalneeded.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //bring back parent tab bar controller
        self.tabBarController?.tabBar.isHidden = false
        
        //fetch data
        fetchData()
        
        //fetch balance
        goalneeded.text = "$" + fetchamt()

    }
    

    //fetching data
    func fetchData() {
        filterData = [] //empty list before feteching data
        if let s = controller.FetchGoalData(){
            filterData = s
            filterData.reverse()
            DispatchQueue.main.async {
                self.historytableView.reloadData()
            }
        }
    }
    
    func fetchamt()->String{
        var b = String(format: "%.2f", controller.getAmount())
        b = "$" + b
        return b
    }
 
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tList = controller.FetchGoalData()!
        return tList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath ) as! HomeTableViewCell

            let tObj = filterData[indexPath.row]
            
            cell.catImageView?.image = tObj.image
            cell.title?.text = tObj.title
            cell.notes?.text = tObj.goal
            cell.price?.text = "+" + String(format: "%.2f",tObj.price) + " SGD"
            print(tObj.title)
            
            
            //Date formatting
            let dateFormatter = DateFormatter()
            let date:Date = tObj.deadline
             
            // British English Locale (en_GB)
            dateFormatter.locale = Locale(identifier: "en_GB")
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd") // // set template after setting locale
            let newDate = dateFormatter.string(from: date) // 31 December
            
            cell.date?.text = newDate
            
            return cell
        
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, sourceView, completionHandler) in completionHandler(true)
            
            //deleting object
            let obj = self.filterData[indexPath.row]
            controller.DeleteGoal(id: String(obj.id))
            filterData.remove(at: indexPath.row)
            goalneeded.text = fetchamt()
            self.tableView.reloadData()
        }

        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
        /*let edit = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in completionHandler(true)
            
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

