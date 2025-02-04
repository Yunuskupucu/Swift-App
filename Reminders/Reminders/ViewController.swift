//
//  ViewController.swift
//  Reminders
//
//  Created by Yunus Emre KÜPÜCÜ on 19.04.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var reminders = [Reminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnAdd(_ sender: UIBarButtonItem) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController else {return}
        
        vc.title = "New Reminder"
        
        vc.completion = { (title,description,date) in
            
            DispatchQueue.main.async{
                self.navigationController?.popToRootViewController(animated: true)
                let newReminder = Reminder(title: title, description: description, date: date, identifier: "id_\(title)")
                self.reminders.append(newReminder)
                self.tableView.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = description
                
                let targetDate = date
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if error != nil{
                        print(error?.localizedDescription ?? "error")
                    }
                }
                
                
            }
        }
        navigationController?.pushViewController(vc, animated: true )
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let row = reminders[indexPath.row]
        cell.textLabel?.text = row.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd,MMMM,YYYY"
        cell.detailTextLabel?.text = formatter.string(from: row.date)
        
        return cell
    }
}

extension ViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil){ (action, sourceView, completionHandler) in
           
            self.reminders.remove(at: indexPath.row)
            self.tableView.reloadData()
          
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .destructive, title: nil){ (action, sourceView, completionHandler) in
            
            let reminder = self.reminders[indexPath.row]
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {succes, error in
                if succes {
                    
                    self.scheduletest(title: reminder.title, body: reminder.description)
                    
                }else if error != nil {
                    print(error?.localizedDescription ?? "error")
                }
            })
            
            completionHandler(true)
        }
        
        doneAction.image = UIImage(systemName: "checkmark")
        doneAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    
    func scheduletest (title: String, body: String){
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        content.body = description
        
        let targetDate = Date().addingTimeInterval(10)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil{
                print(error?.localizedDescription ?? "error")
            }
        }
    }
}

struct Reminder {
    var title: String
    var description: String
    var date: Date
    let identifier: String
}

