//
//  TransferViewController.swift
//  EwanoCash
//
//  Created by Roham on 7/7/1400 AP.
//

import UIKit

protocol TransferViewControllerDelegate: AnyObject {
    func insertedNewData()
}

class TransferViewController: UIViewController {
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var transactionTypeSegment: UISegmentedControl!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var transactionTitletextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var costTransferedLabel: UILabel!
    @IBOutlet weak var datePickerTextField: UITextField!
    
    @IBAction func addButtonAction(_ sender: Any) {
        addButtonDidTapped()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        print("Cancel button perssed")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        refreshDate()
    }
    
    
    @IBAction func transactionTypeSegmentAction(_ sender: Any) {
        if transactionTypeSegment.selectedSegmentIndex == 0 {
            isIncome = true
        }else{
            isIncome = false
        }
    }
    
    weak var delegate: TransferViewControllerDelegate?
    var listOfTransactions = [ TransactionData(title: "Default", amount: 0, date: Date(), isIncome: true)]
    var isIncome = true
    var selectedDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboard()
        transactionTypeSegment.tintColor = UIColor.systemBlue
        transactionTypeSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        transactionTypeSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        todayButton.layer.cornerRadius = 5
        costTransferedLabel.layer.cornerRadius = 25
        costTransferedLabel.clipsToBounds = true
        addButton.layer.cornerRadius = 25
        cancelButton.layer.cornerRadius = 25
        //**********************
        listOfTransactions.remove(at: 0)
        
        if let oldEnteries = UserDefaults.standard.value(forKey:"listOfTransactions") as? Data {
            if let transferData = try? PropertyListDecoder().decode(Array<TransactionData>.self, from: oldEnteries) {
                listOfTransactions = transferData
                if listOfTransactions.isEmpty {
                    print("UserDefaults array is empty")
                    currentBalanceLabel.isHidden = false
                    transactionTypeSegment.isHidden = true
                    transactionTitletextField.placeholder = "Type Here"
                    transactionTitletextField.text = "Balance"
                } else {
                    print("UserDefaults array is not empty, it has \(oldEnteries.count) items")
                    currentBalanceLabel.isHidden = true
                    transactionTypeSegment.isHidden = false
                    transactionTitletextField.placeholder = "Title Of This Transaction"
                }
            } else {
                print("UserDefaults array is nil")
            }
        }
        datePickerTextField.layer.borderWidth = 1
        datePickerTextField.layer.cornerRadius = 10
        datePickerTextField.clipsToBounds = true
        refreshDate()
        datePickerTextField.setDatePickerAsInputViewFor(target: self, selector: #selector(dateSelected))
        priceTextField.delegate = self
        transactionTitletextField.delegate = self
        transactionTitletextField.addCloseToolbar()
        priceTextField.addCloseToolbar()
    }
    
    @objc func dateSelected() {
        if let datePicker = datePickerTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            datePickerTextField.text = dateFormatter.string(from: datePicker.date)
            selectedDate = datePicker.date.description
        }
        datePickerTextField.resignFirstResponder()
    }
}

extension TransferViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension TransferViewController {
    func refreshDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.medium
        datePickerTextField.text = dateFormatter.string(from: date)
        selectedDate = dateFormatter.string(from: date)
    }
    
    func saveDataToUserDefault() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode( listOfTransactions ) , forKey: "listOfTransactions")
    }
    
    func addButtonDidTapped() {
        var transactionTitle = "Default"
        transactionTitle = transactionTitletextField.text ?? ""
        let amount = (Double(priceTextField.text ?? "0") ?? 0)
        let item = TransactionData(title: transactionTitle, amount: amount, date: datePickerTextField.text!.toDate() ?? Date(), isIncome: isIncome)
        listOfTransactions = []
        
        if let data = UserDefaults.standard.value(forKey:"listOfTransactions") as? Data {
            if let transferData = try? PropertyListDecoder().decode(Array<TransactionData>.self, from: data) {
                listOfTransactions = transferData
            }
        }
        listOfTransactions.append(item)
        print("GHGHGHGHG\(listOfTransactions)HGHGHGHGHGH")
        if transactionTitle == "" || transactionTitle == "$" || costTransferedLabel.text == "" {
            let alert = UIAlertController(title: "Incomplete Entry", message: "Please fill all parts", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }  else {
            saveDataToUserDefault()
            delegate?.insertedNewData()
            dismiss(animated: true, completion: nil)
        }
    }
}
