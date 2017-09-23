//
//  TodoListTableViewController.swift
//  iosTodoApp
//
//  Created by Rafael Rodrigues Ghossi on 4/4/17.
//  Copyright © 2017 Rafael Rodrigues Ghossi. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let realm = try! Realm()
    var todoList: Results<Todo>!
    var searchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readTodosAndUpdateUI()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let index  = segmentedControl.selectedSegmentIndex
        var sortBy = "priority"
        if index == 1 {
            sortBy = "dueDate"
        }
        
        todoList = realm.objects(Todo.self).filter("title contains[c] %@", searchText).sorted(byKeyPath: sortBy)
        self.searchText = searchText
        tableView.reloadData()
    }
    
    func readTodosAndUpdateUI() {
        todoList = realm.objects(Todo.self)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        let priority = "[\(todoList[indexPath.row].priority)]"
        let date = "[\(formatter.string(from: todoList[indexPath.row].dueDate))]"
        let title = todoList[indexPath.row].title
        let cellText = "\(priority) \(date) \(title)"
        
        let priorityRange = (cellText as NSString).range(of: priority)
        let dateRange = (cellText as NSString).range(of: date)
        
        let attributedString = NSMutableAttributedString(string:cellText)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red , range: priorityRange)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue , range: dateRange)
        
        cell.textLabel?.attributedText = attributedString

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editTodoSegue", sender: indexPath.row)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todoToBeDeleted = todoList[indexPath.row]
            try! realm.write {
                realm.delete(todoToBeDeleted)
            }
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }   
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "editTodoSegue",
            let destination = segue.destination as? UINavigationController,
            let todoIndex = tableView.indexPathForSelectedRow?.row {
            let targetController = destination.topViewController as? AddTodoViewController
            targetController?.todo = todoList[todoIndex]
        }
    }
    
    
    //MARK: - Actions
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        var sortBy = "priority"
        
        if sender.selectedSegmentIndex == 1 {
            sortBy = "dueDate"
        }
        todoList = realm.objects(Todo.self).filter("title contains[c] %@", searchText).sorted(byKeyPath: sortBy)
        tableView.reloadData()
    }

}
