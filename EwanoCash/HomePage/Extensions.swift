//
//  Extensions.swift
//  EwanoCash
//
//  Created by Alireza on 10/14/21.
//

import Foundation
import UIKit

extension UITextField {
    func addCloseToolbar() {
        let bar = UIToolbar()
        let customFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        let doneButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(hideKeyboard))
        doneButton.setTitleTextAttributes([ NSAttributedString.Key.font: customFont], for: UIControl.State.normal)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [spacer, doneButton]
        bar.sizeToFit()
        self.inputAccessoryView = bar
    }
    
    @objc private func hideKeyboard() {
        self.resignFirstResponder()
    }
    
    func setDatePickerAsInputViewFor(target: Any , selector: Selector){
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 200.0))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 40.0))
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(hideKeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .plain , target: target, action: selector)
        toolBar.setItems([cancel , flexibleSpace , done], animated: false)
        inputAccessoryView = toolBar
    }
}

extension UIViewController {
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
}

extension String {
    func toDate()-> Date? {
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        dateFormatter.dateStyle = DateFormatter.Style.medium
        //        2021-10-12 16:31:11 +0000
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func getStringMonth() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM")
        return df.string(from: self)
    }
    
    func getPrettyDate(format:String = "EEEE, MMM d") -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate(format)
        return df.string(from: self)
    }
    
    func getPrettyTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
