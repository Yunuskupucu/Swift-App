//
//  ViewController.swift
//  ToDoList
//
//  Created by Yunus Emre KÜPÜCÜ on 30.04.2024.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        loadItems()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) // Seçilen satır gri yanıp söner
        
    }
    
    @IBAction func clockPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toPomodoro", sender: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
         
        let alert = UIAlertController(title: "New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text == "" {
                print("Task girilmedi")
                
            }else{
                
                let newItem = Item()
                newItem.title = textField.text!
                
                self.itemArray.append(newItem)
                self.saveItems()
            }
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    
    //MARK: - Save Items
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item array \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Load Items
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item array, \(error)")
            }
        }
    }
    
//MARK: - Delete Items
    func deleteItem(at indexPath: IndexPath) {
        itemArray.remove(at: indexPath.row)
        saveItems()
        tableView.reloadData() // TableView'ı güncelleyin
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(at: indexPath)
        }
    }
}

