//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Evgeniy Maksimov on 01.09.2024.
//

import UIKit

protocol ButtonField {
    func createButton() -> UIButton
}

final class FilledButtonFactory: ButtonField {
    
    let title: String
    let action: UIAction
    let color: UIColor
    
    init(title: String, color: UIColor, action: UIAction) {
        self.title = title
        self.color = color
        self.action = action
    }
    
    func createButton() -> UIButton {
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 20)
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = color
        buttonConfig.attributedTitle = AttributedString(title, attributes: attributes)
        
        let button = UIButton(configuration: buttonConfig, primaryAction: action)
        return button
    }
}

final class NewTaskViewController: UIViewController {
    // MARK: - Public properties
    weak var delegate: NewTaskViewControllerDelegate?
    
    // MARK: - Private properties
    private let storageManager = StorageManager.shared
    
    private lazy var newTaskTF: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "New task"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        let filledButton = FilledButtonFactory(
            title: "Save",
            color: .mIlkBlue,
            action: UIAction { [weak self] _ in
                guard let text = self?.newTaskTF.text, !text.isEmpty else { return }
                guard let task = self?.storageManager.creatNewTask(text) else { return }
                self?.delegate?.addNewTask(task)
                self?.dismiss(animated: true)
        })
        
        let button = filledButton.createButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let filledButton = FilledButtonFactory(
            title: "Cancel",
            color: .milkRed,
            action: UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        let button = filledButton.createButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - View life sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubview(newTaskTF,saveButton, cancelButton)
        setupConstraints()
    }
    // MARK: - Private methods
    private func addSubview(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                newTaskTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                newTaskTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                newTaskTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ]
        )
        NSLayoutConstraint.activate(
            [
                saveButton.topAnchor.constraint(equalTo: newTaskTF.bottomAnchor, constant: 20),
                saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ]
        )
        NSLayoutConstraint.activate(
            [
                cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
                cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ]
        )
    }
}

#Preview {
    NewTaskViewController()
}
