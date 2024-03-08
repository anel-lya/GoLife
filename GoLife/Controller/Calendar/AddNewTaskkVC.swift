import UIKit

class AddNewTaskkViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var dp: UIDatePicker!
    @IBOutlet weak var tf: UITextField!
    @IBOutlet weak var v: UIView!
    
    @IBOutlet weak var tfff: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dp.backgroundColor = .white
        dp.overrideUserInterfaceStyle = .light
        dp.minimumDate = Date.now
        tf.delegate = self
        tfff.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if tf.text == plT {
//            tf.text = ""
//            tf.textColor = .darkText
//        }
//        if tfff.text == plT2 {
//            tfff.text = ""
//            tfff.textColor = .darkText
//        }
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if tf.text!.isEmpty {
//            tf.text = plT
//            tf.textColor = UIColor.lightGray
//        }
//        if tfff.text!.isEmpty {
//            tfff.text = plT2
//            tfff.textColor = UIColor.lightGray
//        }
//    }
    
    @IBAction func add(_ sender: Any) {
        if let title = tf.text, tf.text != ""  {
            let desc = tfff.text ?? "..."
            let date = dp.date
            let res = desc // == plT ? "" : desc
            DataManager.shared.saveAction(q: title + "\n" + res, d: date)
            
            back(sender)
        }
        else {
            showAlert("Title can't be empty")
        }
    }
    
    @IBAction func back (_ sender: Any){
        if let back = storyboard?.instantiateViewController(withIdentifier: "TabBar") as? TabBar {
            back.selectedIndex = 3
            back.modalPresentationStyle = .fullScreen
            present(back, animated: false)
        }
    }
    
    func showAlert (_ message : String) {
        let a = UIAlertController(title: "SORRY", message: "\n" + message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "ok", style: .default))
        self.present(a, animated: true)
    }
}
