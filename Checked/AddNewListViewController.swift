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
    
    @IBAction func save_new_list(_ sender: AnyObject) {
        addNewList(list_name_text_field.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
    }
    
    
    /*
    *
    */
    func addNewList(_ list_name: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext : NSManagedObjectContext = appDelegate.managedObjectContext
        
        let newList = NSEntityDescription.insertNewObject(forEntityName: "List", into: managedObjectContext) as! List
        
        newList.name = list_name
        newList.date_created = Date()
        
        do{
            try managedObjectContext.save()
            self.navigationController?.popViewController(animated: false)
        } catch {
            print(error)
        }
        
    }
    
    
    
    
}
