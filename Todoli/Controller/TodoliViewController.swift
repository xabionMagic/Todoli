//
//  ViewController.swift
//  Todoli
//
//  Created by Saroj on 7/8/19.
//  Copyright © 2019 Saroj. All rights reserved.
//

import UIKit

class TodoliViewController: UITableViewController {

    var todoList = [Item]()
    
    //var defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DataFilePath -
        
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
        
        print(dataFilePath!)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        
        //MARK:- UserDefaults  app loaded data from this.
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            todoList = items
//        }
        
        //Decoded the loaded items by Decoder
        
        loadtodoliList()
        
        
    }
    
    @objc func addNewItem() {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Todoli Item", message: "This is message.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Todoli", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textfield.text!
            newItem.done = true
            self.todoList.append(newItem)
            
            //UserDefaults Singleton.
           // self.defaults.set(self.todoList, forKey: "TodoListArray")
          
            self.saveTodoliList()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Todoli"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

   
    //MARK- TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let todo = todoList[indexPath.row]
        cell.textLabel?.text = todo.title
        
        //ternery operator
        cell.accessoryType = todo.done ? .checkmark : .none
        
//        if todoList[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    //MARK- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(indexPath.row)
        
        todoList[indexPath.row].done = !todoList[indexPath.row].done
        
//        if todoList[indexPath.row].done == false {
//            todoList[indexPath.row].done = true
//        } else {
//            todoList[indexPath.row].done = false
//        }
        saveTodoliList()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
           
        }
    }
    
    
    //MARK:- Model Manupulation Methods
    
    func saveTodoliList() {
        //Encoder
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(todoList)
            try data.write(to: dataFilePath!)
        
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadtodoliList() {
        //Decoder
        guard let data = try? Data(contentsOf: dataFilePath!) else { return }
        let decoder = PropertyListDecoder()
        do {
            todoList = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error decoding item Array, \(error)")
        }
    }
}



