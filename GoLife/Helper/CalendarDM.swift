

import UIKit
import CoreData

class DataManager {
    static let shared = DataManager()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveAction(q : String, d : Date) {
        let loved = Action(context: context)
        
        loved.ddate = d
        loved.aaction = q
        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении данных: \(error)")
        }
    }
    
    func getAllActions() -> [Action] {
        let fetchRequest: NSFetchRequest<Action> = Action.fetchRequest()
        
        do {
            let p = try context.fetch(fetchRequest)
            return p
        } catch {
            print("Ошибка при загрузке данных: \(error)")
            return []
        }
    }
    
    func getActionByDate(_ d : String) -> String {
        let fetchRequest: NSFetchRequest<Action> = Action.fetchRequest()
        let p = try! context.fetch(fetchRequest)
        let evenNumbers = p.filter { String(describing: $0.ddate).contains(d) }
        if evenNumbers.count != 0 {
            return evenNumbers.first!.aaction!
        }
        else {
            return ""
        }
    }
    
    
    func getActionByDate2(_ d : String) -> Action? {
        let fetchRequest: NSFetchRequest<Action> = Action.fetchRequest()
        let p = try! context.fetch(fetchRequest)
        let evenNumbers = p.filter { String(describing: $0.ddate).contains(d) }
        if evenNumbers.count != 0 {
            return evenNumbers.first!
        }
        else {
            return nil
        }
    }
    
    func checkActionByDate(_ d : String) -> Bool {
        let fetchRequest: NSFetchRequest<Action> = Action.fetchRequest()
        
        let p = try! context.fetch(fetchRequest)
        let evenNumbers = p.filter { String(describing: $0.ddate).contains(d) }
        if evenNumbers.count != 0 {
            return true
        }
        else {
            return false
        }
    }
    
    func deleteAction(n: Action) {
        context.delete(n)
        
        do {
            try context.save()
        } catch {
            print("Ошибка при удалении данных: \(error)")
        }
    }
    
    func deleteAllActions() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Action")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error deleting data : \(error)")
        }
        saveContext()
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}


