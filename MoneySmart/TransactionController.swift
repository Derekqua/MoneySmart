//
//  TransactionController.swift
//  MoneySmart
//
//  Created by Derek Qua on 20/1/21.
//

import Foundation
import CoreData
import UIKit

class TransactionController {
    
    var appDelegate:AppDelegate
    let context:NSManagedObjectContext
    
    
    init() {
        //Refering to the container
        appDelegate  = (UIApplication.shared.delegate) as! AppDelegate

        //Create a context for this container
        context = appDelegate.persistentContainer.viewContext
    }
    
    func TransactionDataExist()->Bool {
        var result = false
        //check the Core Data if any data exists.
        var hList:[NSManagedObject] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_Transaction")
        
        do{
            hList = try context.fetch(fetchRequest)
            //check if any data inside core data
            if hList.count < 0{
                result = false
            }
            else{
                result = true
            }
            
        }catch let error as NSError{
            print("Could not Save.\(error), \(error.userInfo)")
        }
        
        
        return result
    }
    
    func FetchTransactionData()->[Transaction]? {
        var hList:[Transaction] = []
        var transaction:[NSManagedObject] = []
        print("test")
        
        //fetch all data in the Core Data and convert the data to hlist
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_Transaction")
        
        do{
            transaction = try context.fetch(fetchRequest)
            
            for c in transaction{
                let id = c.value(forKey: "cd_id") as? Int32
                let datetime = c.value(forKey: "cd_datetime") as? Date
                let title = c.value(forKey: "cd_title") as? String
                let notes = c.value(forKey: "cd_notes") as? String
                let price = c.value(forKey: "cd_price") as? Double
                let type = c.value(forKey: "cd_type") as? String
                let image = c.value(forKey: "cd_image")
                
                let newimage = UIImage(data: image as! Data)
                
                let t1 = Transaction(id: id!, image: newimage!, title: title!, notes: notes!, price: price!, datetime: datetime!, type: type!)
                hList.append(t1)
            }
            try context.save()
        }catch let error as NSError{
            print("Could not Save.\(error), \(error.userInfo)")
        }
        
        
        
        return hList
    }
    
    func AddTransactionData(t:Transaction){
        //takes in a transaction object and write to the Core Data
        
        let entity = NSEntityDescription.entity(forEntityName: "CD_Transaction", in: context)!
        
        let transaction = NSManagedObject(entity: entity, insertInto: context)
        transaction.setValue(t.id, forKey: "cd_id")
        transaction.setValue(t.title, forKey: "cd_title")
        transaction.setValue(t.notes, forKey: "cd_notes")
        transaction.setValue(t.datetime, forKey: "cd_datetime")
        transaction.setValue(t.price, forKey: "cd_price")
        let imageData = t.image.pngData();
        transaction.setValue(imageData, forKey: "cd_image")
        transaction.setValue(t.type, forKey: "cd_type")
        
        //updating balance into coredata
        var price:Double
        if t.type == "Income"{
            price = t.price
        }
        else{
            price = -t.price
        }
        updateBalance(bal: price)
        
        do{
            try context.save()
            print("Transction object Added into coredata")
        }catch let error as NSError{
            print("Could not Save.\(error), \(error.userInfo)")
        }
        
    }
    
    func DeleteTransaction(id:String){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Transaction")
        fetchRequest.predicate = NSPredicate(format: "cd_id == %@", id)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            let objecToDelete = result[0] as! NSManagedObject
            context.delete(objecToDelete)
            
            //delete balance
            let price = objecToDelete.value(forKey: "cd_price") as? Double
            let type = (objecToDelete.value(forKey: "cd_type") as? String)!
            deleteBalance(price: price!, type: type)
            
            do {
                try context.save()
            } catch  {
                print(error)
            }
            
        } catch  {
            print(error)
        }
    }
    
    func DeleteAllTransaction(){
        
        var transaction:[NSManagedObject] = []

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_Transaction")
        
        do{
            transaction = try context.fetch(fetchRequest)
            
            for i in transaction{
                context.delete(i)
            }
            
            //reset to 0
            resetBalance()
            
            do {
                try context.save()
            } catch  {
                print(error)
            }
            
        } catch  {
            print(error)
        }
    }
    
    func UpdateTransaction(t:Transaction){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Transaction")
        fetchRequest.predicate = NSPredicate(format: "cd_id == %@", String(t.id))
        
        do {
            let result = try context.fetch(fetchRequest)
            
            let objecToUpdate = result[0] as! NSManagedObject
            let oldPrice = objecToUpdate.value(forKey: "cd_price") as! Double //old balance before update
            
            objecToUpdate.setValue(t.id, forKey: "cd_id")
            objecToUpdate.setValue(t.title, forKey: "cd_title")
            objecToUpdate.setValue(t.notes, forKey: "cd_notes")
            objecToUpdate.setValue(t.datetime, forKey: "cd_datetime")
            objecToUpdate.setValue(t.price, forKey: "cd_price")
            let imageData = t.image.pngData();
            objecToUpdate.setValue(imageData, forKey: "cd_image")
            objecToUpdate.setValue(t.type, forKey: "cd_type")
            
            //update balance
            //updating balance into coredata
            var price:Double
            if t.type == "Income"{
                price = t.price - oldPrice
            }
            else{
                price = -(t.price - oldPrice)
            }
            
            updateBalance(bal: price)
            
            do {
                try context.save()
            } catch  {
                print(error)
            }
            
        } catch  {
            print(error)
        }
    }
    
    
    
    func GetLatestTransactionId()-> Int32 {
        
        var id:Int32 = 1
        var transaction:[NSManagedObject] = []
        
        
        //fetch all data in the Core Data and convert the data to hlist
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_Transaction")
        
        do{
            transaction = try context.fetch(fetchRequest)
            if transaction.last == nil{
                id = 1
            }
            else{
                let latest = transaction.last
                id = (latest!.value(forKey: "cd_id") as? Int32)! + 1
            }
            
        
            try context.save()
        }catch let error as NSError{
            print("Could not Save.\(error), \(error.userInfo)")
        }
        
        
        
        return id
    }

    
    func updateBalance(bal:Double) {

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CD_Balance")
                
        do {
            
            let transaction = try context.fetch(fetchRequest)
            
            if transaction.first == nil{
                let entity = NSEntityDescription.entity(forEntityName: "CD_Balance", in: context)!
                let t = NSManagedObject(entity: entity, insertInto: context)
                t.setValue(bal, forKey: "cd_balance")
            }
            else{
                let objectUpdate = transaction[0] as! NSManagedObject
                let oldBal = objectUpdate.value(forKey: "cd_balance") as! Double
                let sum = oldBal + bal
                objectUpdate.setValue(sum, forKey: "cd_balance")

            }
            
            do {
                try context.save()
            } catch  {
                print(error)
            }
            
            
        } catch  {
            print(error)
        }
    }
    
    func getBalance()->Double {
        
        var b:Double = 0
        //fetch all data in the Core Data and convert the data to hlist
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_Balance")
        
        do{
            let balance = try context.fetch(fetchRequest)
            
            if balance.first == nil{
                b = 0
            }
            else{
                b = (balance.first!.value(forKey: "cd_balance") as? Double)!
            }
            
            do {
                try context.save()
            } catch  {
                print(error)
            }
            
            
        } catch  {
            print(error)
        }
        
        return b
    }
    
    func deleteBalance(price: Double, type:String)->Double {
        
        var b:Double = 0
        //fetch all data in the Core Data and convert the data to hlist
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_Balance")
        
        do{
            let balance = try context.fetch(fetchRequest)

            let objectUpdate = balance.first!
            b = (objectUpdate.value(forKey: "cd_balance") as? Double)!
            if type == "Income"{
                b -= price
            }
            else{
                b += price
            }
            objectUpdate.setValue(b, forKey: "cd_balance")
            

            do {
                try context.save()
            } catch  {
                print(error)
            }
            
            
        } catch  {
            print(error)
        }
        
        return b
    }
    
    func resetBalance() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CD_Balance")
                
        do {
            
            let transaction = try context.fetch(fetchRequest)
            
            if transaction.first != nil {
                let objectUpdate = transaction[0] as! NSManagedObject
                context.delete(objectUpdate)
            }
            
            do {
                try context.save()
            } catch  {
                print(error)
            }
            
            
        } catch  {
            print(error)
        }
    }
}
