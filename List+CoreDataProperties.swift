//
//  List+CoreDataProperties.swift
//  Checked
//
//  Created by Thuso Mokane on 29/08/16.
//  Copyright © 2016 Thuso Mokane. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension List {

    @NSManaged var completion_status: NSNumber?
    @NSManaged var date_created: NSDate?
    @NSManaged var date_modified: NSDate?
    @NSManaged var name: String?
    @NSManaged var itemsInList: NSSet?

}
