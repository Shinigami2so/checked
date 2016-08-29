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
    @IBAction func save_item(sender: AnyObject) {
    }
    @IBOutlet weak var item_store: UITextField!
    @IBOutlet weak var item_price: UITextField!
    @IBOutlet weak var item_name: UITextField!
    
    
}