//
//  TotalSumViewController.swift
//  EwanoCash
//
//  Created by Reza Kashkoul on 7/11/1400 AP.
//

import UIKit
import AAInfographics

class TotalSummaryViewController: UIViewController {
    
    @IBOutlet var chartParentView: UIView!
    @IBOutlet weak var totalSpendingAmountLabel: UILabel!
    @IBOutlet weak var totalIncomeAmountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var chartView = AAChartView()
    let cellHeight:CGFloat = 60
    var isTableAutoReloadEnabled = true
    var items: [TransactionData] = [] {
        didSet {
            if true {
                DispatchQueue.main.async { [self] in
                    tableView.reloadData()
                    tableViewHeightConstraint.constant = cellHeight * CGFloat(items.count)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Total Summary"
        setpTableView()
        stupChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadChartData()
        fillSummaryLabels()
    }
    
    func setpTableView() {
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func stupChartView() {
        chartParentView.backgroundColor = .clear
        chartView.frame = chartParentView.bounds
        chartParentView.addSubview(chartView)
        chartView.layer.position.x -= 5
    }
    
    func fillSummaryLabels() {
        totalIncomeAmountLabel.text = items.filter({$0.isIncome}).compactMap({$0.amount}).reduce(0, +).description + "$"
        totalSpendingAmountLabel.text = items.filter({!$0.isIncome}).compactMap({$0.amount}).reduce(0, +).description + "$"
    }
}

// MARK: - Data manager
extension TotalSummaryViewController {
    func loadChartData() {
        let gradientColor = AAGradientColor.linearGradient(direction: .toBottom, startColor: "#ADD8F9", endColor: "#ffffff00")
        isTableAutoReloadEnabled = false
        items = getData()
        isTableAutoReloadEnabled = true
        var balance: Int = 0
        var allTransactions: [Int] = []
        for i in 0..<items.count {
            balance = balance + items[i].amount
            allTransactions.append(balance)
        }
        let data = AAChartModel()
        //            .markerRadius(0) // MARK: For Hiding points on the chart
            .chartType(.areaspline)
            .animationType(.easeInCubic)
            .dataLabelsEnabled(false)
            .touchEventEnabled(false)
            .tooltipEnabled(true)
            .legendEnabled(false)
            .dataLabelsEnabled(true)
            .markerSymbolStyle(.innerBlank)
            .categories(items.compactMap({$0.date.getPrettyDate(format: "YYYY, MMM d")}))
            .series([
                AASeriesElement()
                    .name("Balance($)")
                    .data(allTransactions)
                    .color(gradientColor),
            ])
        chartView.aa_drawChartWithChartModel(data)
    }
    
    func getData() -> [TransactionData] {
        if let data = UserDefaults.standard.value(forKey:"listOfTransactions") as? Data {
            if let transferData = try? PropertyListDecoder().decode(Array<TransactionData>.self, from: data) {
                return transferData //+ transferData + transferData + transferData + transferData + transferData + transferData + transferData + transferData + transferData + transferData + transferData + transferData + transferData + transferData + transferData + transferData + transferData + transferData + transferData // MARK: Uncomment to see the mass data
            }
        }
        return []
    }
}

// MARK: - TableView Functions
extension TotalSummaryViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
