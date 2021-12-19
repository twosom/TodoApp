//
//  ViewController.swift
//  TodoApp
//
//  Created by Desire L on 2021/12/19.
//
//

import UIKit


class ViewController: UIViewController {


    @IBOutlet
    var todoTableView: UITableView!


    override
    func viewDidLoad() {
        super.viewDidLoad()

        title = "TODO App"
        makeNavigationBar()

        todoTableView.delegate = self
        todoTableView.dataSource = self
    }

    func makeNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = true

        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTodo))
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
    func addTodo() {

    }

}


// ### EXTENSION ### //
extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        0
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
    }


}
