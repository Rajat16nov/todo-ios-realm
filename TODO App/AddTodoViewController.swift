//
//  AddTodoViewController.swift
//  iosTodoApp
//
//  Created by Rafael Rodrigues Ghossi on 4/4/17.
//  Copyright © 2017 Rafael Rodrigues Ghossi. All rights reserved.
//

import UIKit
import RealmSwift

class AddTodoViewController: UIViewController {
    
    @IBOutlet weak var todoTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var prioritySliderValue: UILabel!
    var todo: Todo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (todo != nil) {
            todoTitleTextField.text = todo?.title
            dueDatePicker.date = (todo?.dueDate)!
            prioritySlider.value = Float((todo?.priority)!)
        }
    }
    
    @IBAction func saveTodo(_ sender: UIBarButtonItem) {
        let realm = try! Realm()
        if (todo != nil) {
            try! realm.write {
                todo?.title = todoTitleTextField.text!
                todo?.dueDate = dueDatePicker.date
                todo?.priority = Int(self.prioritySlider.value)
                dismiss(animated: true, completion: nil)
            }
        } else {
            todo = Todo()
            todo?.title = todoTitleTextField.text ?? ""
            todo?.dueDate = dueDatePicker.date
            todo?.priority = Int(self.prioritySlider.value)
            
            try! realm.write {
                realm.add(todo!)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        
        var currentValue = Int(prioritySlider.value)
        prioritySliderValue.text = "\(currentValue)"
    }
    
}

