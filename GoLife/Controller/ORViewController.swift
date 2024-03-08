import UIKit

class ORViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var first: UITextField!
    @IBOutlet weak var second: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        second.delegate = self
        first.delegate = self
    }

    @IBAction func getRandom(_ sender: Any) {
        
        let a = first.text!
        let b = second.text!
        
        var title = "Error"
        var message = "Enter your choice"
        
        if !a.isEmpty && !b.isEmpty {
            let list = [a, b]
            title =  "Your choice ..."
            message = list.randomElement()!
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            first.text = ""
            second.text = ""
        }
        let alert = UIAlertController(title: title, message:"\n\(message)\n", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okok", style: .default))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

