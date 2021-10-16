//
//  AllExpencesViewController.swift
//  EwanoCash
//
//  Created by Reza Kashkoul on 7/11/1400 AP.
//

import UIKit

class AllExpencesViewController: UIViewController {
    
    @IBOutlet weak var listStatusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items = [TransactionData]()
    var filteredItems = [TransactionData]()
    var daysForSection : [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        tableView.reloadData()
        updateListViewForItems()
        dismissKeyboardWhenTappedAround()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func setupNavigationBar() {
        navigationItem.title = "All Expences"
        let butt = UIBarButtonItem(title: Date().get(.year).description, style: .plain, target: self, action: #selector(navigationYearButtonAction))
        navigationItem.rightBarButtonItem = butt
        

    }
    
    @objc func navigationYearButtonAction() {
        showYearAlertPicker()
    }
    
    func updateListViewForItems() {
        if items.isEmpty {
            listStatusLabel.isHidden = false
            tableView.isHidden = true
        } else {
            listStatusLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    func loadData() {
        navigationItem.rightBarButtonItem?.title = currentYear.description
        items = DataManager.shared.transactions.filter({$0.date.get(.year).description.contains(currentYear.description)})
        daysForSection = items.compactMap{$0.date.getPrettyDate().description}
    }
}

extension AllExpencesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearArray[row].description
    }
    
    func showYearAlertPicker() {
        let alertView = UIAlertController(title: "Choose the year", message: "\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 142))
        pickerView.dataSource = self
        pickerView.delegate = self
        alertView.view.addSubview(pickerView)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let action = UIAlertAction(title: "OK", style: .default, handler: { [self] _ in
            let selectedyear = yearArray[pickerView.selectedRow(inComponent: 0)]
            navigationItem.rightBarButtonItem?.title = selectedyear.description
            currentYear = selectedyear
            loadData()
        })
        alertView.addAction(action)
        alertView.addAction(cancelAction)
        present(alertView, animated: true, completion: {
            pickerView.frame.size.width = alertView.view.frame.size.width
            if let firstIndex = yearArray.firstIndex(of: currentYear) {
                pickerView.selectRow(firstIndex, inComponent: 0, animated: true)
            }
        })
    }
}

extension AllExpencesViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.isEmpty ? items.count : filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        if items.isEmpty { return cell }
        let item = filteredItems.isEmpty ? items[indexPath.row] : filteredItems[indexPath.row]
        cell.fill(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if items.indices.contains(indexPath.row) {
                if let index = items.firstIndex(where: {$0 == items[indexPath.row]}) {
                    items.remove(at: index)
                    DataManager.shared.transactions = items
                    loadData()
                    tableView.reloadData()
                    updateListViewForItems()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension AllExpencesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredItems = items.filter({$0.title.lowercased().contains(searchText.lowercased())})
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func setupSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        
    }
}
