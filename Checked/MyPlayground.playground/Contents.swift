//: Playground - noun: a place where people can play

import UIKit
import CoreData
func prepMOC() -> NSManagedObjectContext{
    let modelUrl = Bundle.main.url(forResource: "Checked", withExtension: "momd")
    guard let model = NSManagedObjectModel.init(contentsOf: modelUrl!) else { fatalError("model not found") }
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    try! psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    
    return context
}

let managedObjectContext = prepMOC()

var list: List


let ent = NSEntityDescription.insertNewObject(forEntityName: "List", into: managedObjectContext) as! List

ent.name = "New"

//ent.setValue("Test", forKey: "name")


//list = NSEntityDescription.insertNewObject(forEntityName: "List", into: managedObjectContext) as! List

//newList.name = "Test"

//managedObjectContext.save

//print(newList.name)



