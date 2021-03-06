//
//  Item+CoreDataProperties.swift
//  Checked
//
//  Created by Thuso Mokane on 08/09/16.
//  Copyright © 2016 Thuso Mokane. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var name: String?
    @NSManaged var price: NSNumber?
    @NSManaged var parentList: List?
    @NSManaged var storeToBuyFrom: Store?

}
