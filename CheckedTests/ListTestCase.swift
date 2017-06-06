//
//  ListTestCase.swift
//  Checked
//
//  Created by Thuso Mokane on 5/25/17.
//  Copyright © 2017 Thuso Mokane. All rights reserved.
//
import Foundation
import CoreData
import XCTest

class ListTestCase: CheckedTests {
    
    var testList: List?
    var testItem: Item?
    var testItem2: Item?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let entity = NSEntityDescription.entity(forEntityName: "List", in: managedObjectContext!)
        testList = List(entity: entity!, insertInto: managedObjectContext)
        testList?.name = "TestList"
        
        //Code to create item
        let entityItem = NSEntityDescription.entity(forEntityName: "Item", in: managedObjectContext!)
        testItem = Item(entity: entityItem!, insertInto: managedObjectContext) as Item
        testItem2 = Item(entity: entityItem!, insertInto: managedObjectContext) as Item
        
        
        do{try managedObjectContext?.save()}
        catch {print(error)}
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testList = nil
    }
    
    func testNewListCreated() {
        XCTAssert(testList?.numberOfLists() == 1, "0 Lists")
    }
    
    func testListHasNoItems() {
        XCTAssert(testList?.numberOfItems() == 0, "Did not return 0 items in list")
    }
    
    func testAddItemsToList() {
        
        //Code to add item to list
        testList?.addItemToList(item: testItem!)
        testList?.addItemToList(item: testItem2!)
        do{try managedObjectContext?.save()}
        catch{print(error)}
        
        XCTAssert(testList?.numberOfItems() == 2, "Wrong number of items")
    }
    
    func testRemoveItemFromList() {
        testList?.addItemToList(item: testItem!)
        testList?.addItemToList(item: testItem2!)
        XCTAssert(testList?.numberOfItems() == 2, "adding items to list failed")
        
        testList?.removeItem(item: testItem!)
        XCTAssert(testList?.numberOfItems() == 1, "removing item from list failed")
        
    }
    
    func testDeleteList() {
        testList?.deleteList()
        XCTAssert(testList?.numberOfLists() == 0)
    }
    
    func testUpdateListName() {
        testList?.updateList(listName: "Road Trip")
        XCTAssert(testList?.name == "Road Trip")
    }
    
    
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
