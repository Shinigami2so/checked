//
//  List.swift
//  Checked
//
//  Created by Thuso Mokane on 29/08/16.
//  Copyright © 2016 Thuso Mokane. All rights reserved.
//

import Foundation
import CoreData
import UIKit
public class List: NSManagedObject {

//    func prepMOC() -> NSManagedObjectContext{
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedObjectContext : NSManagedObjectContext = appDelegate.managedObjectContext
//        
//        return managedObjectContext
//    }
    
    func prepfetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>{
        var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        let name_sort = NSSortDescriptor(key: "name", ascending: true)
        request.predicate = NSPredicate(format: "parentList.name == %@", self.name!)
        request.sortDescriptors = [name_sort]
        
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: managedObjectContext!,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        return fetchedResultsController
    }
    
// Insert code here to add functionality to your managed object subclass
    func numberOfItems() -> Int{
        //return total number of items
        return (prepfetchedResultsController().fetchedObjects?.count)!
    }
    
    
    
}
