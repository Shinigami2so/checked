//
//  Item.swift
//  Checked
//
//  Created by Thuso Mokane on 29/08/16.
//  Copyright © 2016 Thuso Mokane. All rights reserved.
//

import Foundation
import CoreData
import UIKit
public class Item: NSManagedObject {

    func prepMOC() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext : NSManagedObjectContext = appDelegate.managedObjectContext
        
        return managedObjectContext
    }
    
// Insert code here to add functionality to your managed object subclass
    func createItem(itemName: String, itemPrice: NSNumber, store: Store, parentList: List){
        let managedObjectContext = prepMOC()
        self.name = itemName
        self.price = itemPrice
        self.parentList = parentList
        self.storeToBuyFrom = store
        
        do{ try managedObjectContext.save()}
        catch{print(error)}
    }
    
}
