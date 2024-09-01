//
//  ViewController.swift
//  ToDoList
//
//  Created by Evgeniy Maksimov on 01.09.2024.
//

import UIKit

protocol NewTaskViewControllerDelegate: AnyObject {
    func addNewTask(_ task: ToDoTask)
}

final class MainViewController: UITableViewController {
    // MARK: - Private properties
    private var tasks: [ToDoTask] = []
    private let cellID = "task"
    private let storageManager = StorageManager.shared
    
    // MARK: - View life sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        tasks = storageManager.fetchData()
    }
    
    @objc func addTask() {
        let newTaskVC = NewTaskViewController()
        newTaskVC.delegate = self
        present(newTaskVC, animated:  true)
    }
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - Private methods
    private func setupNavigationBar() {
        title = "Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        
        let navBarApearance = UINavigationBarAppearance()
        navBarApearance.backgroundColor = UIColor.mIlkBlue
        navBarApearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarApearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        
        navigationController?.navigationBar.standardAppearance = navBarApearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApearance
    }
}

extension MainViewController: NewTaskViewControllerDelegate {
    func addNewTask(_ task: ToDoTask) {
        tasks.append(task)
        tableView.reloadData()
    }
}

#Preview {
    MainViewController()
}

