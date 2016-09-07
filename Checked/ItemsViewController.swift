//
//  ItemsViewController.swift
//  Checked
//
//  Created by Thuso Mokane on 29/08/16.
//  Copyright © 2016 Thuso Mokane. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    
    var parentList: List?
    var parentListItems: [AnyObject]!
    
    var fetchedResultsController: NSFetchedResultsController!
    var managedObjectContext: NSManagedObjectContext?{
        return (UIApplication.sharedApplication().delegate
            as! AppDelegate).managedObjectContext
    }
    /*
     *
     */
//    func initializeFetchedResultsController() {
//        
//        
//        
////        let request = NSFetchRequest(entityName: "Item")
////        let name_sort = NSSortDescriptor(key: "name", ascending: true)
////        let price_sort = NSSortDescriptor(key: "price", ascending: true)
////        request.predicate = NSPredicate(format: "parentList == %@", parentList!.name!)
////        request.sortDescriptors = [price_sort, name_sort]
//        let request = NSFetchRequest(entityName: "List")
//        let name_sort = NSSortDescriptor(key: "name", ascending: true)
//        request.predicate = NSPredicate(format: "name == %@", parentList!.name!)
//        request.sortDescriptors = [name_sort]
//
//        
//        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
//                                                              managedObjectContext: managedObjectContext!,
//                                                              sectionNameKeyPath: nil,
//                                                              cacheName: nil)
//        
//        
//        do {
//            try fetchedResultsController.performFetch()
//        } catch {
//            fatalError("Failed to initialize FetchedResultsController: \(error)")
//        }
//        
//        
//    }
    
    func initializeItems() {
        parentListItems = parentList?.itemsInList?.allObjects as! [Item]
        print("initializing list")
    }
    
    /*
     *
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("****\(parentList?.name)")
        initializeItems()
//        initializeFetchedResultsController()
        
        
    }
    
    /*
     *
     */
    override func viewDidAppear(animated: Bool) {
//      initializeFetchedResultsController()
        initializeItems()
        table.reloadData()
        self.navigationItem.title = parentList!.name!
    }
    
    /*
     *
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("we have \(parentListItems.count) items in this list")
        return parentListItems.count
    }
    
    /*
     *
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("item_cell", forIndexPath: indexPath) as UITableViewCell
        let item = parentListItems[indexPath.item] as! Item
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "\(item.price)"
        
        return cell
    }
    
    /*
     * Actions on right swipe on a uitableview cell
     */
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let item = parentListItems[indexPath.item] as! Item
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete"){action, index in
            
            //delete object in model
            self.managedObjectContext?.deleteObject(item)
            
            //save model with object deleted
            do{
                try self.managedObjectContext?.save()
            } catch {
                print(error)
            }
            self.initializeItems()
            self.table.reloadData()
        }
        
        //red delete button
        delete.backgroundColor = UIColor.redColor()
        
        
        //return the swipe buttons
        return [delete]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addNewItemSegue" {
            if let destinationViewController = segue.destinationViewController as? AddNewItemViewController {
                destinationViewController.parentList = parentList
                print("Adding Items to \(parentList!.name)")
            }
        }
    }
    
    
    
}