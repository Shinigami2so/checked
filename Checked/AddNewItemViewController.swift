//
//  AddNewItemViewController.swift
//  Checked
//
//  Created by Thuso Mokane on 29/08/16.
//  Copyright © 2016 Thuso Mokane. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddNewItemViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var parentList: List!
    var existingStore: Store!
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var managedObjectContext: NSManagedObjectContext?{
        return (UIApplication.shared.delegate
            as! AppDelegate).managedObjectContext
    }
    
    @IBAction func save_item(_ sender: AnyObject) {
        addNewItem()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var item_store: UITextField!
    @IBOutlet weak var item_price: UITextField!
    @IBOutlet weak var item_name: UITextField!
    
    var autoCompletePossibilities = ["Woolworths", "Choppies", "Pick n Pay", "Sefalana", "SquareMart"]
    var autoComplete = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
    }
    
    
    /*
     *
     */
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
        let name_sort = NSSortDescriptor(key: "name", ascending: true)
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
        
    }
    
    
    
    /*
     *
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        let sectionInfo = self.fetchedResultsController.sections![section]
        
        return sectionInfo.numberOfObjects
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "store_cell", for: indexPath) as UITableViewCell
        
        let store = fetchedResultsController.object(at: indexPath) as! Store
        
        cell.textLabel?.text = store.name
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        item_store.text? = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
    }
    /*
     *
     */
    func addNewItem(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext : NSManagedObjectContext = appDelegate.managedObjectContext
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext) as! Item
        
        newItem.name = item_name.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        newItem.price = (item_price.text! as NSString).doubleValue as NSNumber?
        
        
        
        
        parentList.mutableSetValue(forKey: "itemsInList").add(newItem)
        
        
        //if store exists update the existing record
        if doesStoreExist(storeName: item_store.text!){
            newItem.storeToBuyFrom = existingStore
        }else {
            let newStore = NSEntityDescription.insertNewObject(forEntityName: "Store", into: managedObjectContext) as! Store
            
            newStore.name = item_store.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            newItem.storeToBuyFrom = newStore
        }
        
        
        
        do{
            try parentList.managedObjectContext!.save()
            self.navigationController?.popViewController(animated: false)
        } catch {
            print(error)
        }
    
    }
    
    /*
    *
    */
    func doesStoreExist(storeName: String) -> Bool{
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Store")
        let predicate = NSPredicate(format: "name == %@", storeName)
        fetchRequest.predicate = predicate
        
        do{
        let fetchResults = try self.managedObjectContext!.fetch(fetchRequest) as? [Store]
        if fetchResults!.count > 0 {
            print("\(fetchResults?[0].name) already exists \(fetchResults!.count) times")
            existingStore = fetchResults?[0]
            return true
            }
        } catch { print(error) }
        
        return false
    }
    
}



