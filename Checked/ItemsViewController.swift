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
    
    var selectedListName: String!
    
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
        let name_sort = NSSortDescriptor(key: "name", ascending: true)
        let price_sort = NSSortDescriptor(key: "price", ascending: true)
        request.sortDescriptors = [price_sort, name_sort]
        
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: managedObjectContext!,
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
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
    }
    
    /*
     *
     */
    override func viewDidAppear(animated: Bool) {
        initializeFetchedResultsController()
        table.reloadData()
        self.navigationItem.title = selectedListName
    }
    
    /*
     *
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResultsController.sections![section]
        
        return sectionInfo.numberOfObjects
    }
    
    /*
     *
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("item_cell", forIndexPath: indexPath) as UITableViewCell
        
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Item
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "\(item.price)"
        
        return cell
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
            self.initializeFetchedResultsController()
            self.table.reloadData()
        }
        
        //red delete button
        delete.backgroundColor = UIColor.redColor()
        
        
        //return the swipe buttons
        return [delete]
    }
    
    
    
    
    
}