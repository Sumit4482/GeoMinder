//
//  CoreDataManager.swift
//  GeoMinder-1
//
//  Created by E5000855 on 28/06/24.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    func addReminder(title: String, latitude: Double, longitude: Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not retrieve AppDelegate.")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Reminder", in: managedContext) else {
            print("Could not find entity description for Reminder.")
            return
        }
        
        let reminder = NSManagedObject(entity: entity, insertInto: managedContext)
        reminder.setValue(title, forKey: "title")
        reminder.setValue(latitude, forKey: "latitude")
        reminder.setValue(longitude, forKey: "longitude")
        reminder.setValue(UUID(), forKey: "id")
        
        do {
            try managedContext.save()
            print("Successfully saved reminder.")
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func fetchReminders() -> [Reminder] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not retrieve AppDelegate.")
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        
        do {
            let reminders = try managedContext.fetch(fetchRequest)
            print("Fetched \(reminders.count) reminders.")
            return reminders
        } catch {
            print("Failed to fetch reminders: \(error)")
            return []
        }
    }
    
    func deleteReminder(reminder: Reminder) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not retrieve AppDelegate.")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(reminder)
        
        do {
            try managedContext.save()
            print("Successfully deleted reminder.")
        } catch {
            print("Failed to delete reminder: \(error)")
        }
    }


}
