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

class AddNewItemViewController: UIViewController, UITextFieldDelegate{
    var parentList: List!
    @IBAction func save_item(sender: AnyObject) {
        addNewItem()
    }
    @IBOutlet weak var item_store: UITextField!
    @IBOutlet weak var item_price: UITextField!
    @IBOutlet weak var item_name: UITextField!
    
    
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
    
}