//
//  StorageManager.swift
//  ToDoList
//
//  Created by Evgeniy Maksimov on 01.09.2024.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [ToDoTask] {
        let fetchRequest = ToDoTask.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    func creatNewTask(_ title: String) -> ToDoTask {
        let task = ToDoTask(context: context)
        task.title = title
        saveContext()
        return task
    }
    
    func updateTask(_ task: ToDoTask, with title: String) {
        task.title = title
        saveContext()
    }
    
    func deleteTask(_ task: ToDoTask) {
        context.delete(task)
        saveContext()
    }
}
