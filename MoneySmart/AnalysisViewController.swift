//
//  HistoryViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 19/1/21.
//

import Foundation
import UIKit
import Charts

class AnalysisViewController: UIViewController {
    let controller = TransactionController()
    var tList:[Transaction] = []
    var category:[String] = ["Clothing", "Entertainment", "Food", "Utilities", "Transport", "Uncategorized"]
    var priceList:[Double] = []
    var tType:String = "Income"
    
    @IBOutlet weak var pieChart : PieChartView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
            {
            case 0:
                tType = "Income"
                self.viewDidAppear(true)
            case 1:
                tType = "Expenses"
                self.viewDidAppear(true)
            default:
                break
            }
    }
    
    //settting up pie chart data entry
    var clothDataEntry = PieChartDataEntry()
    var entDataEntry = PieChartDataEntry()
    var foodDataEntry = PieChartDataEntry()
    var utiDataEntry = PieChartDataEntry()
    var transDataEntry = PieChartDataEntry()
    var uncatDataEntry = PieChartDataEntry()
    var dataEntryList = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        inItData() //insert data and data entry
        
        fetchUpdateChart()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inItData() //insert data and data entry
        
        fetchUpdateChart()
    }
    
    func fetchUpdateChart(){
        let chartDataSet = PieChartDataSet(entries: dataEntryList, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor(named: "Red"),UIColor(named: "Orange"),UIColor(named: "Yellow"),UIColor(named: "Green"),UIColor(named: "Blue"),UIColor(named: "Purple")]
        
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = chartData
    }
    
    func inItData(){
        //income part
        tList = getTypeList(type: tType)
        priceList =  separateByCategory(list: tList)
        print(priceList)
        
        dataEntryList = [] //empty array before inserting
        
        if priceList[0] != 0.0{
            clothDataEntry.value = priceList[0]
            clothDataEntry.label = "Clothes"
            dataEntryList.append(clothDataEntry)
        }
        
        
        if priceList[1] != 0.0{
            entDataEntry.value = priceList[1]
            entDataEntry.label = "Entertainment"
            dataEntryList.append(entDataEntry)
        }
        
        
        if priceList[2] != 0.0{
            foodDataEntry.value = priceList[2]
            foodDataEntry.label = "Food"
            dataEntryList.append(foodDataEntry)
        }
        
        
        if priceList[3] != 0.0{
            utiDataEntry.value = priceList[3]
            utiDataEntry.label = "Utility"
            dataEntryList.append(utiDataEntry)
        }
        
        
        if priceList[4] != 0.0{
            transDataEntry.value = priceList[4]
            transDataEntry.label = "Transport"
            dataEntryList.append(transDataEntry)
        }
        
        
        if priceList[5] != 0.0{
            uncatDataEntry.value = priceList[5]
            uncatDataEntry.label = "Uncategorized"
            dataEntryList.append(uncatDataEntry)
        }
        
        
        
    }
    
    func getTypeList(type: String)->[Transaction]{
        var list:[Transaction] = []
        
        let s:[Transaction] = controller.FetchTransactionData()!
        for i in s{
            if i.type == type{
                list.append(i)
            }
        }
        return list
    }
    
    func separateByCategory(list:[Transaction])->[Double]{
        var array:[Double]
        var clothPrice = 0.00
        var entPrice = 0.00
        var foodPrice = 0.00
        var utiPrice = 0.00
        var transPrice = 0.00
        var uncatPrice = 0.00
        var sum = 0.00
        
        if list.isEmpty{
            array = [0.0,0.0,0.0,0.0,0.0,0.0]
        }
        else{
            for i in list{
                sum += abs(i.price)  //abs for expenses price to become positivie
                if i.title == "Clothing"{
                    clothPrice += abs(i.price)
                }
                else if i.title == "Entertainment"{
                    entPrice += abs(i.price)
                }
                else if i.title == "Food"{
                    foodPrice += abs(i.price)
                }
                else if i.title == "Utilities"{
                    utiPrice += abs(i.price)
                }
                else if i.title == "Transport"{
                    transPrice += abs(i.price)
                }
                else{ //uncategorized
                    uncatPrice += abs(i.price)
                }
            }
            array = [clothPrice,entPrice,foodPrice,utiPrice,transPrice,uncatPrice,sum]
        }
        
        return array
    }


}
