//
//  CalendarViewController.swift
//  SwiftCase
//
//  Created by wtf on 2017/5/2.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit
import EventKit

class CalendarViewController: UIViewController, UITextFieldDelegate {
    
    // 通过EKEventStore可以访问Calendar应用中的日历(Calendar)、日历事件(CalendarEvents)、提醒(Reminders)
    var eventStore : EKEventStore!
    var calendar: EKCalendar!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var eventCalendario: UITextField!
    @IBOutlet weak var titleEvent: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSourceCodeItem("calendar")
        
        eventStore = EKEventStore()
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func dismissKeyBoard() {
        textField.resignFirstResponder()
    }
    
    @IBAction func saveCalendar(_ sender: UIButton) {
        let calendar = EKCalendar(for: .event, eventStore: eventStore)
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                let auxiliar = self.eventStore.sources
                calendar.source = auxiliar.first!
                calendar.title = self.textField.text!
                print(calendar.title)
                do {
                    try! self.eventStore.saveCalendar(calendar, commit: true)
                }
            } else {
                print("Access Denied")
            }
        }
        
    }
    
    @IBAction func saveEvent(_ sender: UIButton) {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                let arrayCalendars = self.eventStore.calendars(for: .event)
                var theCalendar: EKCalendar!
                for calendario in arrayCalendars {
                    if calendario.title == self.eventCalendario.text {
                        theCalendar = calendario
                        print(theCalendar.title)
                    }
                }
                if theCalendar != nil {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = self.titleEvent.text!
                    event.startDate = self.datePicker.date
                    event.endDate = self.datePicker.date.addingTimeInterval(3600)
                    event.calendar = theCalendar
                    do {
                        try! self.eventStore.save(event, span: .thisEvent)
                        let alert = UIAlertController(title: "Calendar", message: "Event created \(event.title) in \(theCalendar.title)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: nil))
                        DispatchQueue.main.async(execute: { 
                            self.present(alert, animated: true, completion: nil)
                        })
                    }
                }
            } else {
                print("Access Denied")
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyBoard()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
