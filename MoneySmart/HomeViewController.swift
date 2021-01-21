//
//  HomeViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 19/1/21.
//

import Foundation
import UIKit

class HomeViewController: UIViewController{
    
    let controller = TransactionController()
    var tList:[Transaction] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        viewtbl.register(nib, forCellReuseIdentifier: "HomeTableViewCell")
        viewtbl.delegate = self
        viewtbl.dataSource = self
        //fetch data
        fetchData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //bring back parent tab bar controller
        self.tabBarController?.tabBar.isHidden = false
        
        //fetch data
        fetchData()

    }
    
    //fetching data
    func fetchData() {
        if let s = controller.FetchTransactionData(){
            tList = s
            DispatchQueue.main.async {
                self.viewtbl.reloadData()
            }
        }
    }
    
    
    @IBOutlet weak var viewtbl: UITableView!
    @IBOutlet weak var balanceText: UILabel!
    
    
    

}
extension HomeViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "TransactionDetailsViewController") as? TransactionDetailsViewController
        let obj = tList[indexPath.row]
        vc?.tImage = obj.image
        vc?.tNotes = obj.notes
        //vc?.tDate = obj.datetime
        vc?.tTitle = obj.title
        vc?.tPrice = String(obj.price)
        vc?.type = obj.type
        

        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension HomeViewController: UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tList = controller.FetchTransactionData()!
        return tList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath ) as! HomeTableViewCell
        
        tList = controller.FetchTransactionData()!
        tList.reverse() //To show latest transaction on top
        let tObj = tList[indexPath.row]
        
        cell.catImageView?.image = tObj.image
        cell.title?.text = tObj.title
        cell.notes?.text = tObj.notes
        cell.price?.text = String(tObj.price)
        cell.date?.text = "Testing"
        
        return cell
    }
    
}
