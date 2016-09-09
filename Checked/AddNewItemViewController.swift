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

class AddNewItemViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{
    var parentList: List!
    @IBAction func save_item(sender: AnyObject) {
        addNewItem()
    }
    @IBOutlet weak var item_store: UITextField!
    @IBOutlet weak var item_price: UITextField!
    @IBOutlet weak var item_name: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var autoCompletePossibilities = ["Woolworths", "Choppies", "Pick n Pay", "Sefalana", "SquareMart"]
    var autoComplete = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        item_store.delegate = self
        tableView.delegate = self
    }
    
    
    /*
     *
     */
    func addNewItem(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext : NSManagedObjectContext = appDelegate.managedObjectContext
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: managedObjectContext) as! Item
        
        let newStore = NSEntityDescription.insertNewObjectForEntityForName("Store", inManagedObjectContext: managedObjectContext) as! Store
        
        newItem.name = item_name.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        newItem.price = (item_price.text! as NSString).doubleValue
        
        newStore.name = item_store.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        newItem.storeToBuyFrom = newStore
        
        parentList.mutableSetValueForKey("itemsInList").addObject(newItem)
        
//        do{
//            try newItem.managedObjectContext!.save()
//        } catch {
//            print(error)
//        }
        
        do{
            try parentList.managedObjectContext!.save()
            self.navigationController?.popViewControllerAnimated(false)
        } catch {
            print(error)
        }
    
    }
    
    
    /*
     *
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let index = indexPath.row as Int
        
        cell.textLabel?.text = autoComplete[index]
        
        return cell
        
    }
    
    /*
     *
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoComplete.count
    }
    
    /*
     *
    */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let substring = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        searchAutocompleteEntriesWithSubstring(substring)
        
        return true
    }
    
    /*
    *
    */
    func textFieldDidBeginEditing(textField: UITextField) {
        tableView.hidden = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        tableView.hidden = false
    }
    
    /*
     *
    */
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autoComplete.removeAll(keepCapacity: false)
        
        for key in autoCompletePossibilities
        {
            let lowkey = key.lowercaseString
            let myString:NSString! = lowkey as String
            
            let substringRange :NSRange! = myString.rangeOfString(substring.lowercaseString)
            
            if (substringRange.location == 0)
            {
                autoComplete.append(key)
            }
        }
        tableView.reloadData()
    }
    
    /*
     *
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        item_store.text = selectedCell.textLabel?.text
        
        tableView.hidden = true
    }
    
}