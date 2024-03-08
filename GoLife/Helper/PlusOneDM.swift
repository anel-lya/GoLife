import UIKit
import CoreData

class PlusOneDM {
    static let shared = PlusOneDM()

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveTrue(int : Int) {
        let loved = Entityy(context: context)
        
        loved.chislo = Int32(int)
        
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        let strTod = localDateFormatter.string(from: date)

        loved.ddate = strTod
        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении данных: \(error)")
        }
    }
 
    func fetchLast() -> Entityy? {
        let fetchRequest: NSFetchRequest<Entityy> = Entityy.fetchRequest()
        
        do {
            let p = try context.fetch(fetchRequest)
            if p.count > 0 {
                return p.last!
            }
            else {
                return nil
            }
        } catch {
            print("Ошибка при загрузке данных: \(error)")
            return nil
        }
    }

    
}


