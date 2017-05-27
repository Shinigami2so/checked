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
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var managedObjectContext: NSManagedObjectContext?{
        return (UIApplication.shared.delegate
            as! AppDelegate).managedObjectContext
    }
    
    /*
     *
     */
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        let name_sort = NSSortDescriptor(key: "name", ascending: true)
        let date_sort = NSSortDescriptor(key: "date_created", ascending: true)
        request.sortDescriptors = [name_sort, date_sort]
        
        
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
        
        self.table.layer.borderWidth = 1
        //        self.table.layer.cornerRadius = 25
        self.table.layer.shadowColor = UIColor.black.cgColor
        self.table.layer.shadowOffset = CGSize.zero
        self.table.layer.shadowRadius = 3
        self.table.layer.shadowOpacity = 1
        
    }
    
    /*
     *
     */
    override func viewDidAppear(_ animated: Bool) {
        initializeFetchedResultsController()
        table.reloadData()
    }
    
    /*
     *
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionInfo = self.fetchedResultsController.sections![section]
        
        return sectionInfo.numberOfObjects
    }
    
    /*
    *
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list_cell", for: indexPath) as UITableViewCell
        
        let list = fetchedResultsController.object(at: indexPath) as! List
        
        cell.textLabel?.text = list.name
        cell.detailTextLabel?.text = "\(list.numberOfItems())"
        
        return cell
    }
    
    /*
     * Actions on right swipe on a uitableview cell
     */
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let list = fetchedResultsController.object(at: indexPath) as! List
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete"){action, index in
            
            //delete object in model
            self.managedObjectContext?.delete(list)
            
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
        delete.backgroundColor = UIColor.red
        
        
        //return the swipe buttons
        return [delete]
    }
    
    /*
    *
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedList = fetchedResultsController.object(at: indexPath) as! List
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "view_items_in_list" {
            if let destinationViewController = segue.destination as? ItemsViewController {
                let selectedIndex = self.table.indexPath(for: sender as! UITableViewCell)
                selectedList = fetchedResultsController.object(at: selectedIndex!) as! List
                destinationViewController.parentList = selectedList
                print("Looking at \(selectedList.name)")
            }
        }
    }
    
    
    
    
    
    
    
    
}
