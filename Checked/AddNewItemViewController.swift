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

class AddNewItemViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{
    var parentList: List!
    @IBAction func save_item(_ sender: AnyObject) {
        addNewItem()
    }
    @IBOutlet weak var item_store: UITextField!
    @IBOutlet weak var item_price: UITextField!
    @IBOutlet weak var item_name: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var autoCompletePossibilities = ["Woolworths", "Choppies", "Pick n Pay", "Sefalana", "SquareMart"]
    var autoComplete = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        item_store.delegate = self
        tableView.delegate = self
    }
    
    
    /*
     *
     */
    func addNewItem(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext : NSManagedObjectContext = appDelegate.managedObjectContext
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext) as! Item
        
        let newStore = NSEntityDescription.insertNewObject(forEntityName: "Store", into: managedObjectContext) as! Store
        
        newItem.name = item_name.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        newItem.price = (item_price.text! as NSString).doubleValue as NSNumber?
        
        newStore.name = item_store.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        newItem.storeToBuyFrom = newStore
        
        parentList.mutableSetValue(forKey: "itemsInList").add(newItem)
        
//        do{
//            try newItem.managedObjectContext!.save()
//        } catch {
//            print(error)
//        }
        
        do{
            try parentList.managedObjectContext!.save()
            self.navigationController?.popViewController(animated: false)
        } catch {
            print(error)
        }
    
    }
    
    
    /*
     *
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        let index = indexPath.row as Int
        
        cell.textLabel?.text = autoComplete[index]
        
        return cell
        
    }
    
    /*
     *
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoComplete.count
    }
    
    /*
     *
    */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        searchAutocompleteEntriesWithSubstring(substring)
        
        return true
    }
    
    /*
    *
    */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = false
    }
    
    /*
     *
    */
    func searchAutocompleteEntriesWithSubstring(_ substring: String)
    {
        autoComplete.removeAll(keepingCapacity: false)
        
        for key in autoCompletePossibilities
        {
            let lowkey = key.lowercased()
            let myString:NSString! = lowkey as String as NSString!
            
            let substringRange :NSRange! = myString.range(of: substring.lowercased())
            
            if (substringRange.location == 0)
            {
                autoComplete.append(key)
            }
        }
        tableView.reloadData()
    }
    
    /*
     *
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        
        item_store.text = selectedCell.textLabel?.text
        
        tableView.isHidden = true
    }
    
}
