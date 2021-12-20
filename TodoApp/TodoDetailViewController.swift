//
//  TodoDetail.swift
//  TodoApp
//
//  Created by Desire L on 2021/12/19.
//
//

import UIKit
import CoreData


protocol TodoDetailViewControllerDelegate: AnyObject {
    func didFinishSaveData()
}

class TodoDetailViewController: UIViewController {

    weak var delegate: TodoDetailViewControllerDelegate?

    private let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    private var priority: PriorityLevel?

    var selectedTodoEntity: TodoEntity?

    @IBOutlet
    var titleTextField: UITextField!

    @IBOutlet
    var lowButton: UIButton!

    @IBOutlet
    var normalButton: UIButton!

    @IBOutlet
    var highButton: UIButton!

    @IBOutlet
    var deleteButton: UIButton!

    @IBOutlet
    var saveButton: UIButton!
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
    }

    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let selectedTodoEntity: TodoEntity = selectedTodoEntity else {
            deleteButton.isHidden = true
            return
        }
        titleTextField.text = selectedTodoEntity.title
        priority = PriorityLevel(rawValue: selectedTodoEntity.priorityLevel)
        deleteButton.isHidden = false
        saveButton.setTitle("Update", for: .normal)
        makePriorityButtonDesign()
    }

    override
    func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [lowButton, normalButton, highButton].forEach { button in
            button.layer.cornerRadius = button.bounds.height / 2
        }
    }

    @IBAction
    func setPriority(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            priority = .LOW
        case 2:
            priority = .NORMAL
        case 3:
            priority = .HIGH
        default:
            break
        }
        makePriorityButtonDesign()
    }

    func makePriorityButtonDesign() {
        [lowButton, normalButton, highButton].forEach { button in
            button.backgroundColor = .clear
        }
        guard let priority = priority else {
            return
        }


        switch priority {
        case .LOW:
            lowButton.backgroundColor = priority.color
        case .NORMAL:
            normalButton.backgroundColor = priority.color
        case .HIGH:
            highButton.backgroundColor = priority.color
        }
    }

    @IBAction
    func saveTodo(_ sender: UIButton) {
        if selectedTodoEntity != nil {
            updateTodo()
        } else {
            saveTodo()
        }
        appDelegate.saveContext()
        delegate?.didFinishSaveData()
        dismiss(animated: true)
    }

    func saveTodo() {
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "TodoEntity", in: context) else {
            return
        }
        guard let todoEntity: TodoEntity = NSManagedObject(entity: entityDescription, insertInto: context) as? TodoEntity else {
            return
        }
        todoEntity.title = titleTextField.text
        todoEntity.date = Date.now
        todoEntity.uuid = UUID()
        todoEntity.priorityLevel = priority?.rawValue ?? PriorityLevel.LOW.rawValue
    }


    func updateTodo() {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        guard let uuid = getSelectedTodoUUID() else {
            return
        }
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)

        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        do {
            let loadedData: [TodoEntity] = try context.fetch(fetchRequest)
            guard let findTodoEntity = loadedData.first else {
                return
            }
            findTodoEntity.title = titleTextField.text
            findTodoEntity.date = Date.now
            findTodoEntity.priorityLevel = priority?.rawValue ?? PriorityLevel.LOW.rawValue
        } catch {
            print(error)
        }
    }

    @IBAction
    func deleteTodo(_ sender: UIButton) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        guard let uuid = getSelectedTodoUUID() else {
            return
        }
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid as CVarArg)
        do {
            let loadedData: [TodoEntity] = try context.fetch(fetchRequest)
            if let findTodoEntity = loadedData.first {
                context.delete(findTodoEntity)
                appDelegate.saveContext()
            }
        } catch {
            print(error)
        }

        delegate?.didFinishSaveData()
        dismiss(animated: true)

    }


    private func getSelectedTodoUUID() -> UUID? {
        guard let selectedTodoEntity = selectedTodoEntity else {
            return nil
        }
        return selectedTodoEntity.uuid
    }

}
