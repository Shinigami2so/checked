//
//  AddNewListViewController.swift
//  Checked
//
//  Created by Thuso Mokane on 29/08/16.
//  Copyright © 2016 Thuso Mokane. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AddNewListViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var list_name_text_field: UITextField!
    
    @IBAction func save_new_list(sender: AnyObject) {
        addNewList(list_name_text_field.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
    }
    
    
    /*
    *
    */
    func addNewList(list_name: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedObjectContext : NSManagedObjectContext = appDelegate.managedObjectContext
        
        let newList = NSEntityDescription.insertNewObjectForEntityForName("List", inManagedObjectContext: managedObjectContext) as! List
        
        newList.name = list_name
        newList.date_created = NSDate()
        
        do{
            try managedObjectContext.save()
            self.navigationController?.popViewControllerAnimated(false)
        } catch {
            print(error)
        }
        
    }
    
    
    
    
}