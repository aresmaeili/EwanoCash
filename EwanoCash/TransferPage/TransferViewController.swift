//
//  TransferViewController.swift
//  EwanoCash
//
//  Created by Roham on 7/7/1400 AP.
//

import UIKit

class TransferViewController: UIViewController {
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonAcion(_ sender: Any) {
        
    }
    @IBAction func transactionTypeSegmentAction(_ sender: Any) {
        if transactionTypeSegment.selectedSegmentIndex == 0 {
            isIncome = true
            print (isIncome)
        }else{
            isIncome = false
            print (isIncome)
            
        }
    }
    @IBOutlet weak var transactionTypeSegment: UISegmentedControl!
    @IBOutlet weak var transactionTitletextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBAction func continueButtonAction(_ sender: Any) {
        ContinueButtonDidTapped()
    }
    @IBOutlet weak var numbersCollectionView: UICollectionView!
    @IBOutlet weak var costTransferedLabel: UILabel!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBAction func refreshButtonAction(_ sender: Any) {
        refreshDate()
    }
    var listOfTransactions: [TransfersModel] = []
    
    var isIncome = true
    var selectedDate: Date?
    let keyPadArray = ["1","2","3","4","5","6","7","8","9", "." , "0" , "←"]
    var cost : String = "" {
        didSet{
            costTransferedLabel.text = cost
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKeyboard()
        //**********************
        //listOfTransactions.remove(at: 0)
        
        datePickerTextField.layer.borderWidth = 1
        datePickerTextField.layer.cornerRadius = 10
        datePickerTextField.clipsToBounds = true
        numbersCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        numbersCollectionView.delegate = self
        numbersCollectionView.dataSource = self
        numbersCollectionView.bounces = false
        refreshDate()
        datePickerTextField.setDatePickerAsInputViewFor(target: self, selector: #selector(dateSelected))
    }
    
    @objc func dateSelected() {
        if let datePicker = datePickerTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM-dd-yyyy"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(identifier: "UTC")!
            
            dateFormatter.dateStyle = .medium
            datePickerTextField.text = dateFormatter.string(from: datePicker.date)
            selectedDate = datePicker.date
            //print("ABDBABDBABDBABDBABD**********\(selectedDate)**8")
        }
        datePickerTextField.resignFirstResponder()
    }
}

extension TransferViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyPadArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = numbersCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.numbersButton.setTitle(keyPadArray[indexPath.row], for: .normal)
        cell.numbersButton.isUserInteractionEnabled = false
        if keyPadArray[indexPath.row] == "." || keyPadArray[indexPath.row] == "←" {
            cell.numbersButton.tintColor = .purple
           
        }else{
            cell.numbersButton.tintColor = .systemBlue
        }
        if keyPadArray[indexPath.row] == "."{
            cell.numbersButton.titleLabel?.font = .boldSystemFont(ofSize: 32.0)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(collectionView.frame.width)/3   , height: Int(collectionView.frame.height)/4)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if keyPadArray[indexPath.row] == "←" {
            if cost.isEmpty {
            }else{
                cost.removeLast()
            }
        }else{
            cost = cost + keyPadArray[indexPath.row]
        }
    }
}

extension UITextField {
    
    func setDatePickerAsInputViewFor(target: Any , selector: Selector){
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 200.0))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 40.0))
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tapCancel))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .plain , target: target, action: selector)
        toolBar.setItems([cancel , flexibleSpace , done], animated: false)
        inputAccessoryView = toolBar
    }
    
    @objc func tapCancel(){
        self.resignFirstResponder()
    }
}

extension TransferViewController {
    
    func refreshDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "YY, MMM d"
        dateFormatter.dateStyle = DateFormatter.Style.medium
        datePickerTextField.text = dateFormatter.string(from: date)
        selectedDate = date
    }
    
    func saveDataToUserDefault() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode( listOfTransactions ) , forKey: "listOfTransactions")
    }
    
    func ContinueButtonDidTapped(){
        var transactionTitle = "Default"
        transactionTitle = transactionTitletextField.text ?? ""
        let item = TransfersModel(titleOfTransaction: transactionTitle, amountOfTransaction: cost, dateOfTransaction: selectedDate!, isIncome: isIncome)
        //  item = TransfersModel()
        listOfTransactions = []

        
        if let data = UserDefaults.standard.value(forKey:"listOfTransactions") as? Data {
            if let transferData = try? PropertyListDecoder().decode(Array<TransfersModel>.self, from: data) {
                listOfTransactions = transferData
            }
        }
        
        listOfTransactions.append(item)
//        cost = ""
        print("GHGHGHGHG\(listOfTransactions)HGHGHGHGHGH")
        

        if transactionTitle == "" || transactionTitle == "$" || costTransferedLabel.text == "" {
            let alert = UIAlertController(title: "Incomplete Entry", message: "Please fill all parts", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
        else {

            saveDataToUserDefault()
            dismiss(animated: true, completion: nil)
        }
        
        else {

            saveDataToUserDefault()
            dismiss(animated: true, completion: nil)
        }

        
        
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
