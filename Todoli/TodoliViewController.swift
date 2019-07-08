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
        // Do any additional setup after loading the view.
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



