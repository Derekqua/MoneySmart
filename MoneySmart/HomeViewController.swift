//
//  HomeViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 19/1/21.
//

import Foundation
import UIKit

class HomeViewController: UIViewController{
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        viewtbl.delegate = self
        viewtbl.dataSource = self
        
        
        
    }
    @IBOutlet weak var viewtbl: UITableView!
    
    
    

    @IBOutlet weak var balanceText: UILabel!
    
    
    

}
extension HomeViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("test")
    }
}
extension HomeViewController: UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath )
        let controller = TransactionController()
        var tlist:[Transaction] = []
        tlist = controller.FetchTransactionData()!
        
        cell.textLabel?.text = tlist[0].title
        cell.detailTextLabel?.text = String(tlist[0].price)
        return cell
    }
    
}
