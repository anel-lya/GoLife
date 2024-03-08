

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var list : [Action] = []
    var selectedDate: Date = Date()
    let calendar = Calendar.current
    
    var months: [Date] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list = DataManager.shared.getAllActions()
        
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let currentDate = Date()
        let currentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
        let nextMonth2 = calendar.date(byAdding: .month, value: 2, to: currentMonth)!
        
        months.append(previousMonth)
        months.append(currentMonth)
        months.append(nextMonth)
        months.append(nextMonth2)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let itemWidth = collectionView.frame.width / 7
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let month = months[indexPath.section]
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        let startOffset = (weekday + 5) % 7 // Учитываем понедельник как первый день
        
        
        let range = calendar.range(of: .day, in: .month, for: month)!
        let dayOfMonth = indexPath.item - startOffset + 1
        
        
        if !(indexPath.item == 35) && !(indexPath.item < startOffset || (dayOfMonth-1 >= range.count)){
       
            let currentDate = calendar.date(byAdding: .day, value: dayOfMonth - 1, to: firstDayOfMonth)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: currentDate)
            let res = DataManager.shared.getActionByDate(dateString)
            
            let alert = UIAlertController(title: res, message: dateString, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "ok", style: .default, handler: {_ in
                    print(11)
            })
            let delAction = UIAlertAction(title: "delete", style: .destructive, handler: {_ in
                if let t = DataManager.shared.getActionByDate2(dateString){
                    DataManager.shared.deleteAction(n: t)
                }
                self.collectionView.reloadData()
            })
            alert.addAction(delAction)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 36
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let month = months[indexPath.section]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        collectionView.backgroundColor = back
        cell.backgroundColor = back
        
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month))!
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        let startOffset = (weekday + 5) % 7 // Учитываем понедельник как первый день
        
        let range = calendar.range(of: .day, in: .month, for: month)!
        let dayOfMonth = indexPath.item - startOffset + 1
        
        if indexPath.item == 35 {
            let currentDate = calendar.date(byAdding: .day, value: dayOfMonth - 1, to: firstDayOfMonth)!
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCellMonth", for: indexPath) as! CalendarCellMonth
            
            let str = UIViewController()
            let h = cell.frame.size.height
            let w = str.view.frame.width
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            let monthName = dateFormatter.string(from: currentDate)
            
            cell.frame.size = CGSize(width: w, height: h)
            cell.monthLabel.text = monthName
            cell.monthLabel.textColor = front
            return cell
        }
        else {
            
            if indexPath.item < startOffset || (dayOfMonth-1 >= range.count){
                cell.configure(with: "", isToday: false, iss: false) // 0 - нет дня для отображения
            }
            else{
                let currentDate = calendar.date(byAdding: .day, value: dayOfMonth - 1, to: firstDayOfMonth)!
                let currentDat = calendar.date(byAdding: .day, value: dayOfMonth, to: firstDayOfMonth)!
                
                let str = "\(currentDat)".prefix(10)
                let res = DataManager.shared.checkActionByDate(String(str))
                let isToday = calendar.isDateInToday(currentDate)
                cell.dayLabel.textColor = front
                cell.configure(with: "\(dayOfMonth)", isToday: isToday, iss: res)
            }
            
            return cell
        }
    }
}


class CalendarCellMonth: UICollectionViewCell {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var separ : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.textColor = front
        contentView.backgroundColor = back
        // Настройка constraints
        NSLayoutConstraint.activate([
            monthLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        separ.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка constraints
        NSLayoutConstraint.activate([
            separ.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            separ.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            // Размер для первого типа ячейки
            return CGSize(width: 100, height: 100)
        } else {
            // Размер для второго типа ячейки
            return CGSize(width: 150, height: 150)
        }
    }

}



class CalendarCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textColor = front
        dayLabel.backgroundColor = back
        contentView.backgroundColor = back
        // Настройка constraints
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with day: String, isToday: Bool, iss : Bool) {
        dayLabel.text = day
        
        if isToday  {
            dayLabel.textColor = UIColor.systemBlue
        }
        else if iss {
            dayLabel.textColor = UIColor.systemBlue
        }
        else {
            dayLabel.textColor = front
        }
    }
}
