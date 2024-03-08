import UIKit
import Foundation

class PlusOneVC: UIViewController {

    @IBOutlet weak var lbl: UILabel!
    var tf = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if let iss = PlusOneDM.shared.fetchLast() {
            print(iss.chislo, iss.ddate!)
            var chislo = Int(iss.chislo)
            
            let t = daysBetweenDates(iss.ddate!)
            print(t)
            if (t > 0) {
                chislo += t
                PlusOneDM.shared.saveTrue(int: Int(chislo))
            }
            self.lbl.text = String(chislo)

        } else {
            print("no no no")
        }
        
    }
    


    @IBAction func refresh(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "enter number for “plus one”", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "1"
            textField.textAlignment = .center
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive)
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "start", style: .default, handler: {
            _ in
            guard let textField = alertController.textFields?.first,
              let nameToSave = textField.text else {
                return
            }
            guard let int = Int(nameToSave) else {
                return
            }
            if int >= 0 && int < 99000 {
                PlusOneDM.shared.saveTrue(int: int)
                self.lbl.text = nameToSave
            }
        })
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
 
    func daysBetweenDates( _ endDate: String) -> Int {
        let calendar = Calendar.current

        
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date()
        
        
        let strEnd = "\(endDate)".prefix(10)
        let strTod = localDateFormatter.string(from: date)
        
        let dateEnd = localDateFormatter.date(from: String(strEnd))!
        let dateTod = localDateFormatter.date(from: strTod)!
        
        print("strEnd - \(strEnd)")
        print("strTod - \(strTod)")
        
        let components = calendar.dateComponents([.day], from: dateEnd, to: dateTod)
        print("com - \(components.day!)")
        
        
        return components.day!
    }
    
}

