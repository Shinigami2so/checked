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
    
    var fetchedResultsController: NSFetchedResultsController!
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "List")
        let name_sort = NSSortDescriptor(key: "name", ascending: true)
        let date_sort = NSSortDescriptor(key: "date_created", ascending: true)
        request.sortDescriptors = [name_sort, date_sort]
        
        var managedObjectContext: NSManagedObjectContext?{
            return (UIApplication.sharedApplication().delegate
                as! AppDelegate).managedObjectContext
        }
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
    }
    
    override func viewDidAppear(animated: Bool) {
        initializeFetchedResultsController()
        table.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResultsController.sections![section]
        
        return sectionInfo.numberOfObjects
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("list_cell", forIndexPath: indexPath) as UITableViewCell
        
        let list = fetchedResultsController.objectAtIndexPath(indexPath) as! List
        
        cell.textLabel?.text = list.name
        
        return cell
    }
    
}