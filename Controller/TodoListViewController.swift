//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBarTint: UISearchBar!
    var todoItems:Results<Item>?
    
    let realm = try! Realm()
    var selectedCategory:Category?{
        didSet{
            loadItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color{
            
            
            
            title = selectedCategory!.name
            guard let navBar  = navigationController?.navigationBar else {fatalError("Navigation Cotroller does not exist.")}
          
            
            if let navBarColor = UIColor(hexString: colorHex){
                navBar.barTintColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(navBarColor, returnFlat: true)]
                searchBarTint.backgroundColor = navBarColor
            }
            
            
          
        }
    }
    
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let iteam = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = iteam.title
            
            cell.accessoryType = iteam.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
                
            
        }else{
            cell.textLabel?.text = "No Items added"
        }
        
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func updateModel(at indexPath: IndexPath)
    {
        if let itemForDeletion = self.todoItems?[indexPath.row]{
            
            do {
                try self.realm.write {
                    
                    self.realm.delete(itemForDeletion)
                }
            } catch  {
                print("Error on deleteing")
            }
            
        }
        
    }
    
    
    //MARK: - Tableview deligate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let  item = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done  = !item.done
                }
            }catch{
                print("Error Saving Data\(error)")
            }
        }
        tableView.reloadData()
        
    }
    //MARK: - Add new Iteam
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Iteam", message: "", preferredStyle: .alert)
        
        let action  = UIAlertAction(title: "Add iteam", style: .default) { (action) in
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        print("Hello")
                    }
                }catch{
                    print("Error Saving new items,\(error)")
                }
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New iteam"
            textField = alertTextField
            print("now")
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func loadItem(){
        todoItems = selectedCategory?.items.sorted(byKeyPath:"title", ascending: true)
    }
    
   
}


    

