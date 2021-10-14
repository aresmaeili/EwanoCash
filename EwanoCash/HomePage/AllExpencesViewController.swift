//
//  AllExpencesViewController.swift
//  EwanoCash
//
//  Created by Reza Kashkoul on 7/11/1400 AP.
//

import UIKit

class AllExpencesViewController: UIViewController {
    
    @IBOutlet weak var listStatusLabel: UILabel!
    @IBOutlet weak var allExpencesTableView: UITableView!
    
    var items = [TransactionData]()
    var daysForSection : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allExpencesTableView.delegate = self
        allExpencesTableView.dataSource = self
        navigationItem.title = "All Expences"
        tabBarController?.selectedIndex = 1
        allExpencesTableView.separatorStyle = .none
        allExpencesTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataFromUserDefault()
        allExpencesTableView.reloadData()
        updateListViewForItems()
    }
    
    func updateListViewForItems() {
        if items.isEmpty {
            listStatusLabel.isHidden = false
            allExpencesTableView.isHidden = true
        } else {
            listStatusLabel.isHidden = true
            allExpencesTableView.isHidden = false
        }
    }
    
    func saveDataToUserDefault() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode( items ) , forKey: "listOfTransactions")
    }
    
    func loadDataFromUserDefault() {
        
        if let data = UserDefaults.standard.value(forKey:"listOfTransactions") as? Data {
            if let transferData = try? PropertyListDecoder().decode(Array<TransactionData>.self, from: data) {
                items = transferData
                daysForSection = items.compactMap{$0.date.getPrettyDate().description}
                DispatchQueue.main.async {
                    self.allExpencesTableView.reloadData()
                }
            }
        }
    }
}

extension AllExpencesViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        if items.isEmpty { return cell }
        if items.indices.contains(indexPath.row) {
            let item = items[indexPath.row]
            cell.itemTitle.text = item.title
            cell.itemDate.text = item.date.getPrettyDate()
            if item.isIncome {
                cell.itemImage.image = UIImage(named: "chevron_down")
                cell.itemImage.tintColor = .systemGreen
                cell.itemPrice.text = item.amount.description
            } else {
                cell.itemImage.image = UIImage(named: "chevron_up")
                cell.itemImage.tintColor = .systemRed
                cell.itemPrice.text = item.amount.description
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return daysForSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return daysForSection[section]
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //            tableView.beginUpdates()
            items.remove(at: indexPath.section)
            
            saveDataToUserDefault()
            tableView.deleteRows(at: [indexPath], with: .fade)
            //            tableView.endUpdates()
            tableView.reloadData()
            updateListViewForItems()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
