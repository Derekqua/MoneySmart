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
        
        //fetch all data in the Core Data and convert the data to hlist
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_Transaction")
        
        do{
            transaction = try context.fetch(fetchRequest)
            
            for c in transaction{
                let datetime = c.value(forKey: "cd_datetime") as? Date
                let title = c.value(forKey: "cd_title") as? String
                let notes = c.value(forKey: "cd_notes") as? String
                let price = c.value(forKey: "cd_price") as? Double
                let image = c.value(forKey: "cd_image") as? UIImage
                
                let t1 = Transaction(image: image!, title: title!, notes: notes!, price: price!, datetime: datetime!)
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
        transaction.setValue(t.title, forKey: "cd_title")
        transaction.setValue(t.notes, forKey: "cd_notes")
        transaction.setValue(t.datetime, forKey: "cd_datetime")
        transaction.setValue(t.price, forKey: "cd_price")
        transaction.setValue(t.image, forKey: "cd_image")
        
        do{
            try context.save()
            print("Transction object Added into coredata")
        }catch let error as NSError{
            print("Could not Save.\(error), \(error.userInfo)")
        }
        
    }
    
    func DeleteTransaction(notes:String){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Transaction")
        fetchRequest.predicate = NSPredicate(format: "cd_notes = %@", notes)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            let objecToDelete = result[0] as! NSManagedObject
            context.delete(objecToDelete)
            
            do {
                try context.save()
            } catch  {
                print(error)
            }
            
        } catch  {
            print(error)
        }
    }
    
    func updateBalance(bal:Double) {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CD_Balance")
        //fetchRequest.predicate = NSPredicate(format: "mobileno = %@", mobileno)
                
        do {
            
            let transaction = try context.fetch(fetchRequest)
            
            let objectUpdate = transaction[0] as! NSManagedObject
            objectUpdate.setValue(bal, forKey: "cd_balance")

            
            do {
                try context.save()
            } catch  {
                print(error)
            }
            
            
        } catch  {
            print(error)
        }
    }
    
    func resetBalance() {
        let bal:Double = 0
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CD_Balance")
        //fetchRequest.predicate = NSPredicate(format: "mobileno = %@", mobileno)
                
        do {
            
            let transaction = try context.fetch(fetchRequest)
            
            let objectUpdate = transaction[0] as! NSManagedObject
            objectUpdate.setValue(bal, forKey: "cd_balance")

            
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
