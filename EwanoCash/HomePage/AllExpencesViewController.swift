//
//  AllExpencesViewController.swift
//  EwanoCash
//
//  Created by Reza Kashkoul on 7/11/1400 AP.
//

import UIKit

class AllExpencesViewController: UIViewController {
    
    @IBOutlet weak var allExpencesTableView: UITableView!
    
    //var items = ["bill" , "buying shoe" , "coffee" , "taxi" , "bill" , "buying shoe" , "coffee" ,"bill" , "buying shoe" , "coffee" ,"bill" , "buying shoe" , "coffee" ,"bill" , "buying shoe" , "coffee"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromUserDefault()
        allExpencesTableView.delegate = self
        allExpencesTableView.dataSource = self
        navigationItem.title = "All Expences"
        tabBarController?.selectedIndex = 1
        allExpencesTableView.separatorStyle = .none
        allExpencesTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
    
    
    
    func loadDataFromUserDefault() {
        
        if let data = UserDefaults.standard.value(forKey:"listOfTransactions") as? Data {
            if let transferData = try? PropertyListDecoder().decode(Array<TransfersModel>.self, from: data) {
                print("*****************\(String(describing: transferData))")
                
                item = transferData
                //items.append(contentsOf: item)
            }
        }
    }
    
    var item = [TransfersModel]()
    let days = [Date]()
    
}

extension AllExpencesViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.itemTitle.text = item[indexPath.row].titleOfTransaction
        cell.itemDate.text = item[indexPath.row].dateOfTransaction.description
        cell.itemPrice.text = item[indexPath.row].amountOfTransaction
        if item[indexPath.row].isIncome == true {
            // cell?.itemImage.image =
        } else {
            //cell?.itemImage.image =
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return days.count
    }
    
    //    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //
    //    }
    
    func getDate() {
        
        let dateString = item[0].dateOfTransaction
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM-dd-yyyy"
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: dateString)
        formatter.dateFormat = "MM"
        let month = formatter.string(from: dateString)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: dateString)
        print(year, month, day) // 2018 12 24
        
        //days.append(dateString)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            item.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            print(item)
        }
        return
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
