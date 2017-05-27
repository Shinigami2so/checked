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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let entity = NSEntityDescription.entity(forEntityName: "List", in: managedObjectContext!)
        testList = List(entity: entity!, insertInto: managedObjectContext)
        testList?.name = "TestList"
        do{try managedObjectContext?.save()}
        catch {print(error)}
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNewListCreated() {
        XCTAssertNotNil(self.testList, "List is nil")
    }
    
    func testListHasNoItems() {
        XCTAssert(testList?.numberOfItems() == 0, "Did not return 0 items in list")
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
