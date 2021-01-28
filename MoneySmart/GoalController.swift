//
//  GoalController.swift
//  MoneySmart
//
//  Created by brandon on 27/1/21.
//

import Foundation
import CoreData
import UIKit

class GoalController {
    
    var appDelegate:AppDelegate
    let context:NSManagedObjectContext
    
    
    init() {
        //Refering to the container
        appDelegate  = (UIApplication.shared.delegate) as! AppDelegate

        //Create a context for this container
        context = appDelegate.persistentContainer.viewContext
    }
    
    func GoalDataExist()->Bool {
        var result = false
        //check the Core Data if any data exists.
        var hList:[NSManagedObject] = []
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_Goal")
        
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
    
    func FetchGoalData()->[Goal]? {
        var hList:[Goal] = []
        var goal:[NSManagedObject] = []
        print("test")
        
        //fetch all data in the Core Data and convert the data to hlist
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_Goal")
        
        do{
            goal = try context.fetch(fetchRequest)
            
            for c in goal{
                let id = c.value(forKey: "cd_id") as? Int32
                let deadline = c.value(forKey: "cd_deadline") as? Date
                let goal = c.value(forKey: "cd_goal") as? String
                let price = c.value(forKey: "cd_price") as? Double
                let image = c.value(forKey: "cd_image")
                let title = c.value(forKey: "cd_title")
                
                let newimage = UIImage(data: image as! Data)
                
                let t1 = Goal(id: id!, image: newimage!, goal: goal!, price: price!, deadline: deadline!, title: title! as! String)
                hList.append(t1)
            }
            try context.save()
        }catch let error as NSError{
            print("Could not Save.\(error), \(error.userInfo)")
        }
        
        
        
        return hList
    }
    
    func AddGoalData(g:Goal){
        //takes in a transaction object and write to the Core Data
        
        let entity = NSEntityDescription.entity(forEntityName: "CD_Goal", in: context)!
        
        let goal = NSManagedObject(entity: entity, insertInto: context)
        goal.setValue(g.id, forKey: "cd_id")
        goal.setValue(g.goal, forKey: "cd_goal")
        goal.setValue(g.deadline, forKey: "cd_deadline")
        goal.setValue(g.price, forKey: "cd_price")
        let imageData = g.image.pngData();
        goal.setValue(imageData, forKey: "cd_image")
        goal.setValue(g.title, forKey: "cd_title")
        
        //updating balance into coredata
        var price:Double
        price = g.price
        
        updateBalance(bal: price)
        
        do{
            try context.save()
            print("Transction object Added into coredata")
        }catch let error as NSError{
            print("Could not Save.\(error), \(error.userInfo)")
        }
        
    }
    
    func DeleteGoal(id:String){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Goal")
        fetchRequest.predicate = NSPredicate(format: "cd_id == %@", id)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            let objecToDelete = result[0] as! NSManagedObject
            context.delete(objecToDelete)
            
            //delete balance
            let price = objecToDelete.value(forKey: "cd_price") as? Double
            deleteBalance(price: price!)
            
            do {
                try context.save()
            } catch  {
                print(error)
            }
            
        } catch  {
            print(error)
        }
    }
    
    func DeleteAllGoal(){
        
        var goal:[NSManagedObject] = []

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_Goal")
        
        do{
            goal = try context.fetch(fetchRequest)
            
            for i in goal{
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
    
    func UpdateGoal(t:Goal){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CD_Goal")
        fetchRequest.predicate = NSPredicate(format: "cd_id == %@", String(t.id))
        
        do {
            let result = try context.fetch(fetchRequest)
            
            let objecToUpdate = result[0] as! NSManagedObject
            let oldPrice = objecToUpdate.value(forKey: "cd_price") as! Double //old balance before update
            
            objecToUpdate.setValue(t.id, forKey: "cd_id")
            objecToUpdate.setValue(t.goal, forKey: "cd_goal")
            objecToUpdate.setValue(t.deadline, forKey: "cd_deadline")
            objecToUpdate.setValue(t.price, forKey: "cd_price")
            let imageData = t.image.pngData();
            objecToUpdate.setValue(imageData, forKey: "cd_image")
            objecToUpdate.setValue(t.title, forKey: "cd_title")
            
            //update balance
            //updating balance into coredata
            var price:Double
            price = t.price - oldPrice
            
            
            
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
    
    
    
    func GetLatestGoalId()-> Int32 {
        
        var id:Int32 = 1
        var goal:[NSManagedObject] = []
        
        
        //fetch all data in the Core Data and convert the data to hlist
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_Goal")
        
        do{
            goal = try context.fetch(fetchRequest)
            if goal.last == nil{
                id = 1
            }
            else{
                let latest = goal.last
                id = (latest!.value(forKey: "cd_id") as? Int32)! + 1
            }
            
        
            try context.save()
        }catch let error as NSError{
            print("Could not Save.\(error), \(error.userInfo)")
        }
        
        
        
        return id
    }

    
    func updateBalance(bal:Double) {

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CD_GoalAmount")
                
        do {
            
            let goal = try context.fetch(fetchRequest)
            
            if goal.first == nil{
                let entity = NSEntityDescription.entity(forEntityName: "CD_GoalAmount", in: context)!
                let t = NSManagedObject(entity: entity, insertInto: context)
                t.setValue(bal, forKey: "cd_goalamount")
            }
            else{
                let objectUpdate = goal[0] as! NSManagedObject
                let oldBal = objectUpdate.value(forKey: "cd_goalamount") as! Double
                let sum = oldBal + bal
                objectUpdate.setValue(sum, forKey: "cd_goalamount")

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
    
    func getAmount()->Double {
        
        var b:Double = 0
        //fetch all data in the Core Data and convert the data to hlist
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_GoalAmount")
        
        do{
            let balance = try context.fetch(fetchRequest)
            
            if balance.first == nil{
                b = 0
            }
            else{
                b = (balance.first!.value(forKey: "cd_goalamount") as? Double)!
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
    
    func deleteBalance(price: Double)->Double {
        
        var b:Double = 0
        //fetch all data in the Core Data and convert the data to hlist
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CD_GoalAmount")
        
        do{
            let balance = try context.fetch(fetchRequest)

            let objectUpdate = balance.first!
            b = (objectUpdate.value(forKey: "cd_goalamount") as? Double)!
            
            b -= price
            
           
            objectUpdate.setValue(b, forKey: "cd_goalamount")
            

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
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "CD_GoalAmount")
                
        do {
            
            let goal = try context.fetch(fetchRequest)
            
            if goal.first != nil {
                let objectUpdate = goal[0] as! NSManagedObject
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
