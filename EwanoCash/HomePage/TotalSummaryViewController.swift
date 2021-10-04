//
//  TotalSumViewController.swift
//  EwanoCash
//
//  Created by Reza Kashkoul on 7/11/1400 AP.
//

import UIKit

class TotalSummaryViewController: UIViewController {
    
    @IBOutlet var summaryChartView: UIView!
    @IBOutlet weak var totalSpendingAmountLabel: UILabel!
    @IBOutlet weak var totalIncomeAmountLabel: UILabel!
    @IBOutlet weak var totalSummaryTableView: UITableView!
    
    var items = ["bill" , "buying show" , "coffee" , "taxi" , "bill" , "buying show" , "coffee" , "taxi" , "bill" , "buying show" , "coffee" , "taxi"]
    override func viewDidLoad() {
        super.viewDidLoad()
        totalSummaryTableView.delegate = self
        totalSummaryTableView.dataSource = self
        navigationItem.title = "Total Summary"
        totalSummaryTableView.separatorStyle = .none
        summaryChartView.layer.cornerRadius = 25
        summaryChartView.clipsToBounds = true
        totalSummaryTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
}

extension TotalSummaryViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.itemTitle.text = items[indexPath.row]
        cell.itemPrice.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            print(items)
        }
        return
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
}
