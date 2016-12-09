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
    @IBAction func save_item(_ sender: AnyObject) {
        addNewItem()
    }
    @IBOutlet weak var item_store: UITextField!
    @IBOutlet weak var item_price: UITextField!
    @IBOutlet weak var item_name: UITextField!
    
    var autoCompletePossibilities = ["Woolworths", "Choppies", "Pick n Pay", "Sefalana", "SquareMart"]
    var autoComplete = [String]()
    
    /*
     *
     */
    func addNewItem(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext : NSManagedObjectContext = appDelegate.managedObjectContext
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext) as! Item
        
        let newStore = NSEntityDescription.insertNewObject(forEntityName: "Store", into: managedObjectContext) as! Store
        
        newItem.name = item_name.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        newItem.price = (item_price.text! as NSString).doubleValue as NSNumber?
        
        newStore.name = item_store.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        newItem.storeToBuyFrom = newStore
        
        parentList.mutableSetValue(forKey: "itemsInList").add(newItem)
        
//        do{
//            try newItem.managedObjectContext!.save()
//        } catch {
//            print(error)
//        }
        
        do{
            try parentList.managedObjectContext!.save()
            self.navigationController?.popViewController(animated: false)
        } catch {
            print(error)
        }
    
    }
    
}



