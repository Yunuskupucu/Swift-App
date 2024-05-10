//
//  AddViewController.swift
//  Reminders
//
//  Created by Yunus Emre KÜPÜCÜ on 20.04.2024.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    public var completion: ((String,String,Date)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(btnSave))
        
    }
    
    @objc func btnSave() {
        
        if let titleText = titleLabel.text, !titleText.isEmpty,
           let descriptionText = descriptionLabel.text, !descriptionText.isEmpty{
            let targetDate = datePicker.date
            completion?(titleText,descriptionText,targetDate)
        }
    }
}
