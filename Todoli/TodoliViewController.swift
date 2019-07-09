//
//  ViewController.swift
//  Todoli
//
//  Created by Saroj on 7/8/19.
//  Copyright © 2019 Saroj. All rights reserved.
//

import UIKit

class TodoliViewController: UITableViewController {

    var todoList = ["Buy Apple", "Buy Orange", "Buy Banana"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
    }
    
    @objc func addNewItem() {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Todoli Item", message: "This is message.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Todoli", style: .default) { (action) in
            
            self.todoList.append(textfield.text!)
            
            self.tableView.reloadData()
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
        cell.textLabel?.text = todoList[indexPath.row]
        return cell 
    }
    
    //MARK- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none

        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



