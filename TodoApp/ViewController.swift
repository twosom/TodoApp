//
//  ViewController.swift
//  TodoApp
//
//  Created by Desire L on 2021/12/19.
//
//

import UIKit
import CoreData

enum PriorityLevel: Int16 {
    case LOW
    case NORMAL
    case HIGH
}

extension PriorityLevel {
    var color: UIColor {
        switch self {
        case .LOW:
            return .green
        case .NORMAL:
            return .orange
        case .HIGH:
            return .red
        }
    }
}

class ViewController: UIViewController {

    private let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    var todoList = [TodoEntity?]()

    var dateFormatter: DateFormatter = DateFormatter()

    @IBOutlet
    var todoTableView: UITableView!


    override
    func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"

        title = "TODO App"
        makeNavigationBar()

        todoTableView.delegate = self
        todoTableView.dataSource = self
        fetchData()
        //TODO MAIN-ASYNC?
        todoTableView.reloadData()
    }

    func fetchData() {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        do {
            todoList = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }

    func makeNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        navigationBar.prefersLargeTitles = true

        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTodo))
        item.tintColor = .black.withAlphaComponent(0.7)
        navigationItem.rightBarButtonItem = item

        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .blue.withAlphaComponent(0.2)

        /**
         - Note: Navigation 바 영역의 색상을 변환
         */
        navigationBar.standardAppearance = barAppearance
        navigationBar.scrollEdgeAppearance = barAppearance
    }


    @objc
    func addNewTodo() {
        let detailVC = TodoDetailViewController(nibName: "TodoDetailViewController", bundle: nil)
        detailVC.delegate = self
        present(detailVC, animated: true)
    }

}


// ### EXTENSION ### //
extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let todoCell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            return TodoCell()
        }

        if let todoEntity = todoList[indexPath.row] {
            todoCell.topTitleLabel.text = todoEntity.title
            //## IF EXISTS DATE
            if let hasDate = todoEntity.date {
                todoCell.dateLabel.text = dateFormatter.string(from: hasDate)
            } else {
                todoCell.dateLabel.text = ""
            }

            let priorityColor = PriorityLevel(rawValue: todoEntity.priorityLevel)?.color
            todoCell.priorityView.backgroundColor = priorityColor

        }
        return todoCell
    }
}


extension ViewController: TodoDetailViewControllerDelegate {
    func didFinishSaveData() {
        fetchData()
        todoTableView.reloadData()
    }


}
