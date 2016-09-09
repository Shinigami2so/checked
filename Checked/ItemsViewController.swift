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

class ItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet var table: UITableView!
    let CURRENCY = "BWP"
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
    func initializeFetchedResultsController() {
        
        let request = NSFetchRequest(entityName: "Item")
        let store_sort = NSSortDescriptor(key: "storeToBuyFrom.name", ascending: true)
        let name_sort = NSSortDescriptor(key: "name", ascending: true)
        let price_sort = NSSortDescriptor(key: "price", ascending: true)
        request.predicate = NSPredicate(format: "parentList.name == %@", parentList!.name!)
        request.sortDescriptors = [store_sort, price_sort, name_sort]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: managedObjectContext!,
                                                              sectionNameKeyPath: "storeToBuyFrom.name",
                                                              cacheName: nil)
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        
    }
    
    
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
//        initializeItems()
        initializeFetchedResultsController()
        
        
    }
    
    /*
     *
     */
    override func viewDidAppear(animated: Bool) {
        initializeFetchedResultsController()
//        initializeItems()
        table.reloadData()
        self.navigationItem.title = parentList!.name!
    }
    
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    /*
     *
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    /*
     *
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
//        let cell = tableView.dequeueReusableCellWithIdentifier("item_cell", forIndexPath: indexPath) as UITableViewCell
//        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Item
//        cell.textLabel?.text = item.name!+" @"+(item.storeToBuyFrom?.name)!
//        cell.detailTextLabel?.text = "\(CURRENCY) \(item.price!)"
//        
//        return cell
        let cell = tableView.dequeueReusableCellWithIdentifier("item_cell", forIndexPath: indexPath)
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Item
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "\(CURRENCY) \(item.price!)"
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        
        return nil
    }
    
    
    /*
     * Actions on right swipe on a uitableview cell
     */
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Item
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete"){action, index in
            
            //delete object in model
            self.managedObjectContext?.deleteObject(item)
            
            //save model with object deleted
            do{
                try self.managedObjectContext?.save()
            } catch {
                print(error)
            }
            //self.initializeItems()
            self.initializeFetchedResultsController()
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