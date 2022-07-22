//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Raj  on 27/06/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        title = "Todoey"
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar  = navigationController?.navigationBar else {fatalError("Navigation Cotroller does not exist.")}
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name ?? "No Categories added yet"
            
            
            guard let categoryColor = UIColor(hexString: category.color) else{ fatalError()}
            
                cell.backgroundColor = UIColor(hexString:category.color ?? "1D9BF6")
                
            cell.textLabel?.textColor = categoryColor.ContrastColorOf(returnFlat: true)
            }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    
    
    //MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        tableView.reloadData()
        var textField = UITextField()
        let alert  = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.random.hexValue()
            self.saveCategories(category: newCategory)
            
        }
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Category"
            
        }
        alert.addAction(action)
        present(alert,animated: true)
        
        
    }
    //MARK: - Data Manipulation Methods
    func saveCategories(category:Category){
        
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error Saving Category \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            
            do {
                try self.realm.write {
                    
                    self.realm.delete(categoryForDeletion)
                }
            } catch  {
                print("Error on deleteing")
            }
            
        }
    }
    
    
    //MARK: - TableView Deligate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath =  tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}





extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
    func ContrastColorOf(returnFlat: Bool) -> UIColor {
        return UIColor(contrastingBlackOrWhiteColorOn: self, isFlat: returnFlat)
    }

}
