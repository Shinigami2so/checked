//
//  ListsViewController.swift
//  Checked
//
//  Created by Thuso Mokane on 28/08/16.
//  Copyright © 2016 Thuso Mokane. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class ListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    
    var selectedList: List!
    
    var fetchedResultsController: NSFetchedResultsController!
    var managedObjectContext: NSManagedObjectContext?{
        return (UIApplication.sharedApplication().delegate
            as! AppDelegate).managedObjectContext
    }
    /*
     *
     */
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "List")
        let name_sort = NSSortDescriptor(key: "name", ascending: true)
        let date_sort = NSSortDescriptor(key: "date_created", ascending: true)
        request.sortDescriptors = [name_sort, date_sort]
        
//        var managedObjectContext: NSManagedObjectContext?{
//            return (UIApplication.sharedApplication().delegate
//                as! AppDelegate).managedObjectContext
//        }
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("list_cell", forIndexPath: indexPath) as UITableViewCell
        
        let list = fetchedResultsController.objectAtIndexPath(indexPath) as! List
        
        cell.textLabel?.text = list.name
        //cell.detailTextLabel?.text = "open list"
        
        return cell
    }
    
    /*
     * Actions on right swipe on a uitableview cell
     */
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let list = fetchedResultsController.objectAtIndexPath(indexPath) as! List
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete"){action, index in
            
            //delete object in model
            self.managedObjectContext?.deleteObject(list)
            
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
    
    /*
    *
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedList = fetchedResultsController.objectAtIndexPath(indexPath) as! List
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "view_items_in_list" {
            if let destinationViewController = segue.destinationViewController as? ItemsViewController {
                let selectedIndex = self.table.indexPathForCell(sender as! UITableViewCell)
                selectedList = fetchedResultsController.objectAtIndexPath(selectedIndex!) as! List
                destinationViewController.selectedListName = selectedList.name
            }
        }
    }
    
    
    
    
    
    
    
    
}