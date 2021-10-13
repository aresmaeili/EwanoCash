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
    
    var items = [TransfersModel]()
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
            if let transferData = try? PropertyListDecoder().decode(Array<TransfersModel>.self, from: data) {
                // print("*****************\(String(describing: transferData))")
                items = transferData
                daysForSection = items.compactMap{$0.dateOfTransaction.getPrettyDate().description}
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
        let dateFormatter = DateFormatter()
       // dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        cell.itemTitle.text = items[indexPath.section].titleOfTransaction
        cell.itemDate.text = items[indexPath.section].dateOfTransaction.getPrettyTime()
        
        cell.itemPrice.text = items[indexPath.section].amountOfTransaction.description
        if items[indexPath.section].isIncome == true {
            cell.itemImage.image = UIImage(named: "chevron_down")
        } else {
            cell.itemImage.image = UIImage(named: "chevron_up")
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
