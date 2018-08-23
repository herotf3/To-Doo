//
//  To Doo
//
//  Created by MacBook on 8/23/18.
//  Copyright © 2018 tps. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    public let REUSE_CELL_ID="Cell"
    public let TODO_ARR="ToDoArray"
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArr=[Item]()

    //-----
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_CELL_ID, for: indexPath)
        
        // Configure the cell...
        let item=itemArr[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell=tableView.cellForRow(at: indexPath)
        //toggle checked and unchecked
        let item=itemArr[indexPath.row]
        
        item.done = !item.done
        cell?.accessoryType = item.done ? .checkmark : .none
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItems()
    }
    
    //MARK: Action
    
    @IBAction func addToDo(_ sender: Any) {
        
        var textfield=UITextField()
        //show alert for user write content of todo
        let alert = UIAlertController(title: "Add new task", message: "Type your task below", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Add", style: .default) { (action) in
            print("Added \(textfield.text!)")
            
            let item=Item(context: self.context)
            item.title=textfield.text ?? "stub"
            item.done=false
            
            self.itemArr.append(item)
            self.tableView.reloadData()
            
            self.saveItems()
        }
        alert.addTextField { (todoTf) in
            todoTf.placeholder="What to do?"
            textfield=todoTf
        }
        
        alert.addAction(action)
        
        //modally show alert
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Model manipulation Methods
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("Error in saving context: \(error)")
        }
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        
        do{
            try itemArr=context.fetch(request)
        }catch{
            print("\(error)")
        }
        tableView.reloadData()
    }
}

//MARK: SearchBar Delegate
extension ToDoTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //query for searching
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //order by
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadItems()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0 {
            loadItems()
            DispatchQueue.main.async {
                //to change UI in main thread
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
