//
//  SettingViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 19/1/21.
//

import Foundation
import UIKit
import UniformTypeIdentifiers
import UserNotifications

class SettingViewController: UIViewController, UIDocumentPickerDelegate {

    let controller = TransactionController()
    let goal = GoalController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func notify(_ sender: UISwitch)
    {
        if (sender.isOn == true)
        {
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.alert,.sound]) { (granted, error) in
                
            }
            
            //create notification content
            let content = UNMutableNotificationContent()
            content.title = "Hey I'm a notification!"
            content.body = "Remember to add your expenses!"
            
            //create notification trigger
            let date = Date().addingTimeInterval(10)
            
            let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            //create the request
            let uuidString = UUID().uuidString
            
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            //register notification center
            center.add(request) { (error) in
                //check the error paremeter and handle any errors
                
            }
            
            print("Notification success")
            
        }
        else
        {
        }
    }
    
    
    
    @IBAction func exportCsv(_ sender: Any) {
        //file name
        let sFileName = "MoneySmart.csv"
        
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let documentURL = URL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(sFileName)
        
        let output = OutputStream.toMemory()
        
        let csvWriter = CHCSVWriter(outputStream: output, encoding: String.Encoding.utf8.rawValue, delimiter: ",".utf16.first!)
        
        //header for csv file
        csvWriter?.writeField("ID")
        csvWriter?.writeField("Title")
        csvWriter?.writeField("Notes")
        csvWriter?.writeField("Price")
        csvWriter?.writeField("Date")
        csvWriter?.writeField("Type")
        csvWriter?.finishLine() //specify new line
        
        //array to add data for the employee
        var data = [[String]]()
    
        if let s = controller.FetchTransactionData(){
            for i in s{
                //Date formatting
                let dateFormatter = DateFormatter()
                let date:Date = i.datetime

                // Set Date Format
                dateFormatter.dateFormat = "YY/MM/dd"

                // Convert Date to String
                let newDate = dateFormatter.string(from: date)
                
                data.append([String(i.id), i.title, i.notes, String(i.price), newDate, i.type])
            }
        }
        
        for (elements) in data.enumerated(){
            csvWriter?.writeField(elements.element[0]) //id
            csvWriter?.writeField(elements.element[1]) //title
            csvWriter?.writeField(elements.element[2]) //notes
            csvWriter?.writeField(elements.element[3]) //price
            csvWriter?.writeField(elements.element[4]) //newdata
            csvWriter?.writeField(elements.element[5]) //type
            csvWriter?.finishLine() //new line

        }
        
        csvWriter?.closeStream()
        
        let buffer  = (output.property(forKey: .dataWrittenToMemoryStreamKey) as? Data)!
        
        do{
            try buffer.write(to: documentURL)
        }
        catch{
            
        }
    }
    
    @IBAction func importCsv(_ sender: Any) {
        let supportedFile:[UTType] = [UTType.data]
        
        let vController = UIDocumentPickerViewController(forOpeningContentTypes: supportedFile, asCopy: true)
        
        vController.delegate = self
        vController.allowsMultipleSelection = false
         
        present(vController, animated: true, completion: nil)
        
        
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("a file was selected")
        
        let rows = NSArray(contentsOfCSVURL: url, options: CHCSVParserOptions.sanitizesFields)!
        
        var pass = 1
        for row in rows{
            if pass == 1{ //skip the header
                pass += 1
            }
            else{
                print(row)
                
                let row1 = row as! [String]
                //Create a transaction object
                
                //Date formatting
                let dateFormatter = DateFormatter()

                // Set Date Format
                dateFormatter.dateFormat = "YY/MM/dd"

                // Convert Date to String
                let newDate = dateFormatter.date(from: row1[4])
                
                let t1 = Transaction(id: Int32(row1[0])!, image: UIImage(named: row1[1])!, title: row1[1], notes: row1[2], price: Double(row1[3])!, datetime: newDate! , type: row1[5])
                
                let controller = TransactionController()
                controller.AddTransactionData(t: t1)

            }
            
           

            
            
        }
    }
    
    @IBAction func clearBtn(_ sender: Any) {
        controller.DeleteAllTransaction()
        goal.DeleteAllGoal()
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
