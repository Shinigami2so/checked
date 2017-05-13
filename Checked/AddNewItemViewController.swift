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
    var isNewItem = true
    var editItem: Item!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
        
        if !isNewItem{
            item_store.text = editItem.storeToBuyFrom?.name
            item_name.text = editItem.name
            item_price.text = "\(editItem.price!)"
        }
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "store_cell", for: indexPath) as UITableViewCell
        let store = fetchedResultsController.object(at: indexPath) as! Store
        
        cell.textLabel?.text = store.name
        
        return cell
    }
    
    /*
     *
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        item_store.text? = (tableView.cellForRow(at: indexPath)?.textLabel?.text)!
    }
    
    /*
     *
     */
    func addNewItem(){
        
        let ds = DataService()
        let item_price_final = (item_price.text! as NSString).doubleValue as NSNumber
        if (ds.createItem(itemName: item_name.text!,itemPrice: item_price_final, parentStoreName: item_store.text!, parentList: parentList)){
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    
}



