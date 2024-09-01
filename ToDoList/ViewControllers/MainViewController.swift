//
//  ViewController.swift
//  ToDoList
//
//  Created by Evgeniy Maksimov on 01.09.2024.
//

import UIKit

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
        showAlert(withTitle: "Добавить новое задание", andMessage: "Что нужно сделать?")
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.deleteTask(task)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        showAlert(withTitle: "Изменить задание", andMessage: "Что нужно сделать?", task: task)
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
    
    private func showAlert(
        withTitle title: String,
        andMessage message: String,
        task: ToDoTask? = nil
    ) {
        
        let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
        )
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let newTitle = alert.textFields?.first?.text, !newTitle.isEmpty else { return }
            if let task {
                storageManager.updateTask(task, with: newTitle)
                tableView.reloadData()
            } else {
                let newTask = storageManager.creatNewTask(newTitle)
                tasks.append(newTask)
                let indexPath = IndexPath(row: tasks.count - 1, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.text = task?.title
        }
        present(alert, animated: true)
    }
}

#Preview {
    MainViewController()
}

