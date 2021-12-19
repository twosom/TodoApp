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

    var priority: PriorityLevel?

    @IBOutlet
    var titleTextField: UITextField!

    @IBOutlet
    var lowButton: UIButton!

    @IBOutlet
    var normalButton: UIButton!

    @IBOutlet
    var highButton: UIButton!

    override
    func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [lowButton, normalButton, highButton].forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
        }
    }

    @IBAction
    func setPriority(_ sender: UIButton) {

        lowButton.backgroundColor = .clear
        normalButton.backgroundColor = .clear
        highButton.backgroundColor = .clear


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
        sender.backgroundColor = priority?.color
    }

    @IBAction
    func saveTodo(_ sender: UIButton) {
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "TodoEntity", in: context) else { return }
        guard let todoEntity: TodoEntity = NSManagedObject(entity: entityDescription, insertInto: context) as? TodoEntity else { return }
        todoEntity.title = titleTextField.text
        todoEntity.date = Date.now
        todoEntity.uuid = UUID()
        todoEntity.priorityLevel = priority?.rawValue ?? PriorityLevel.LOW.rawValue

        appDelegate.saveContext()
        delegate?.didFinishSaveData()
        dismiss(animated: true)

    }

}
