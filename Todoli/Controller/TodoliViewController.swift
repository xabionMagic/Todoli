//
//  ViewController.swift
//  Todoli
//
//  Created by Saroj on 7/8/19.
//  Copyright © 2019 Saroj. All rights reserved.
//

import UIKit
import CoreData

class TodoliViewController: UITableViewController {

    var todoList = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadtodoliList()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //var defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DataFilePath -
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        print(dataFilePath)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        
        //MARK:- UserDefaults  app loaded data from this.
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            todoList = items
//        }
        
        //Decoded the loaded items by Decoder
        
       // loadtodoliList()  --> Its on the selectedCategory variable ..
        
        
    }
    
    @objc func addNewItem() {
        
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Todoli Item", message: "This is message.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Todoli", style: .default) { (action) in
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textfield.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
            
            context.delete(todoList[indexPath.row])
            todoList.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            saveTodoliList()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    //MARK:- Model Manupulation Methods
    
    func saveTodoliList() {
        //CoreData
        
        do {
            try context.save()
        } catch  {
            print("Error with Saveing Context \(error)")
        }
     
        self.tableView.reloadData()
                    //Encoder
            //        let encoder = PropertyListEncoder()
            //        do {
            //            let data = try encoder.encode(todoList)
            //            try data.write(to: dataFilePath!)
            //
            //        } catch {
            //            print("Error encoding item array, \(error)")
            //        }
            //
            //        tableView.reloadData()
    }
    
   // func loadtodoliList() {
                //CoreData
    func loadtodoliList(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
       // let request: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
 
        do {
          todoList = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
                  //Decoder
            //        guard let data = try? Data(contentsOf: dataFilePath!) else { return }
            //        let decoder = PropertyListDecoder()
            //        do {
            //            todoList = try decoder.decode([Item].self, from: data)
            //        } catch {
            //            print("Error decoding item Array, \(error)")
            //        }
   }
}

//MARK:- Search Bar Methods

extension TodoliViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
       
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        loadtodoliList(with: request)
        
        //Used when the func loadtodoliLIst doesn't have any parameters
//        do {
//            todoList = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context, \(error)")
//        }
//        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       if searchBar.text?.count == 0 {
            loadtodoliList()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


