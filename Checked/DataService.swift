//
//  DataService.swift
//  Checked
//
//  Created by Thuso Mokane on 5/13/17.
//  Copyright © 2017 Thuso Mokane. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class DataService {
    
    func prepMOC() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext : NSManagedObjectContext = appDelegate.managedObjectContext
        
        return managedObjectContext
    }
    
    /*
     * Create a new list
     */
    func createList(list_name: String) -> Bool{
        let managedObjectContext : NSManagedObjectContext = prepMOC()
        let newList = NSEntityDescription.insertNewObject(forEntityName: "List", into: managedObjectContext) as! List
        
        newList.name = list_name
        newList.date_created = Date()
        
        do{
            try managedObjectContext.save()
            return true
        } catch {
            print(error)
        }
        return false
        
    }
    
    /*
     *  Create new item
     */
    func createItem(itemName: String, itemPrice: NSNumber, parentStoreName: String, parentList: List) -> Bool{
        var storeName = parentStoreName
        //
        let managedObjectContext : NSManagedObjectContext = prepMOC()
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext) as! Item
        //
        newItem.name = itemName
        newItem.price = itemPrice
        newItem.parentList = parentList
        //
        if(storeName == ""){ storeName = "Other"}
        //
        var parentStore = getStoreByName(storeName: storeName)
        //
        if(parentStore != nil){
            addItemtoStore(item: newItem, store: parentStore!)
        } else {
            createStore(storeName: storeName)
            parentStore = getStoreByName(storeName: storeName)!
            addItemtoStore(item: newItem, store: parentStore!)
            
        }
        
        do{
            try managedObjectContext.save()
            return true
        } catch {
            print(error)
        }
        return false
        
    }
    
    
    /*
     * Create new store
     */
    func createStore(storeName: String){
        let managedObjectContext : NSManagedObjectContext = prepMOC()
        let newStore = NSEntityDescription.insertNewObject(forEntityName: "Store", into: managedObjectContext) as! Store
        newStore.name = storeName
        do{
            try managedObjectContext.save()
        } catch { print(error) }
    }
    
    
    /*
     *  Link item to list
     */
    func addItemToList(item: Item, list: List) -> Bool{
        let managedObjectContext : NSManagedObjectContext = prepMOC()
        list.mutableSetValue(forKey: "itemsInList").add(item)
        
        do{
            try managedObjectContext.save()
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    /*
     *  Link item to store
     */
    func addItemtoStore(item: Item, store: Store) -> Bool{
        let managedObjectContext : NSManagedObjectContext = prepMOC()
        store.mutableSetValue(forKey: "itemsInStore").add(item)
        
        do{
            try managedObjectContext.save()
            return true
        } catch {
            print(error)
        }
        return false
    }
    
    /*
     *  Check if store already exists
     */
    func getStoreByName(storeName: String) -> Store?{
        let managedObjectContext : NSManagedObjectContext = prepMOC()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
        let predicate = NSPredicate(format: "name == %@", storeName)
        fetchRequest.predicate = predicate
        
        do{
            let fetchResults = try managedObjectContext.fetch(fetchRequest) as! [Store]
            if fetchResults.count > 0 {
                print("\(fetchResults[0].name) already exists \(fetchResults.count) times")
                return (fetchResults[0])
                
            }
        } catch { print(error) }
        return nil
    }
    
    /*
     *  Get store list
     */
    func getListsByDate(){
        var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
        let managedObjectContext = prepMOC()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        let name_sort = NSSortDescriptor(key: "name", ascending: true)
        let date_sort = NSSortDescriptor(key: "date_created", ascending: true)
        request.sortDescriptors = [name_sort, date_sort]
        
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    
    /*
     *
     */
//    func getOrCreateStoreWithName(storeName: String) ->Store{
//        let managedObjectContext : NSManagedObjectContext = prepMOC()
//        let store = getStoreByName(storeName: storeName)
//        if(store != nil){
//            return store
//        } else {
//            let newStore = NSEntityDescription.insertNewObject(forEntityName: "Store", into: managedObjectContext!) as! Store
//            newStore.name = item_store.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//            
//            return newStore
//        }
//    }
}
