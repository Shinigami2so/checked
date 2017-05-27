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
    * Create a new list
    */
    func addNewList(_ list_name: String){
        let ds = DataService()
        if (ds.createList(list_name: list_name_text_field.text!)){
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    
    
    
}
