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
    
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var managedObjectContext: NSManagedObjectContext?{
        return (UIApplication.shared.delegate
            as! AppDelegate).managedObjectContext
    }
    /*
     *
     */
    func initializeFetchedResultsController() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
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
        
        self.table.layer.borderWidth = 1
//        self.table.layer.cornerRadius = 25
        self.table.layer.shadowColor = UIColor.black.cgColor
        self.table.layer.shadowOffset = CGSize.zero
        self.table.layer.shadowRadius = 3
        self.table.layer.shadowOpacity = 1
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        
    }
    
    /*
     *
     */
    override func viewDidAppear(_ animated: Bool) {
        initializeFetchedResultsController()
//        initializeItems()
        table.reloadData()
        //calculate the total cost of all items and display
        computeTotalCost()
        
        self.navigationItem.title = parentList!.name!
        
        totalView.layer.shadowColor = UIColor.black.cgColor
        totalView.layer.shadowOpacity = 1
        totalView.layer.shadowOffset = CGSize.zero
        totalView.layer.shadowRadius = 3
    }
    
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    /*
     *
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    /*
     *
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        let cell = tableView.dequeueReusableCellWithIdentifier("item_cell", forIndexPath: indexPath) as UITableViewCell
//        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Item
//        cell.textLabel?.text = item.name!+" @"+(item.storeToBuyFrom?.name)!
//        cell.detailTextLabel?.text = "\(CURRENCY) \(item.price!)"
//        
//        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "item_cell", for: indexPath)
        let item = fetchedResultsController.object(at: indexPath) as! Item
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "\(item.price!)"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        
        return nil
    }
    
    
    /*
     * Actions on right swipe on a uitableview cell
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let item = fetchedResultsController.object(at: indexPath) as! Item
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete"){action, index in
            
            //delete object in model
            self.managedObjectContext?.delete(item)
            
            //save model with object deleted
            do{
                try self.managedObjectContext?.save()
            } catch {
                print(error)
            }
            //self.initializeItems()
            self.initializeFetchedResultsController()
            self.computeTotalCost()
            self.table.reloadData()
        }
        
        //red delete button
        delete.backgroundColor = UIColor.red
        
        
        //return the swipe buttons
        return [delete]
    }
    
    
    func computeTotalCost(){
        var total = 0.00
        
        var listItems = parentList?.itemsInList?.allObjects as! [Item]
        
        for currentItem in listItems{
            total += currentItem.price as! Double
        }
        
        self.totalLabel.text = "\(total)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewItemSegue" {
            if let destinationViewController = segue.destination as? AddNewItemViewController {
                destinationViewController.parentList = parentList
                print("Adding Items to \(parentList!.name)")
            }
        }
    }
    
    
    
}
