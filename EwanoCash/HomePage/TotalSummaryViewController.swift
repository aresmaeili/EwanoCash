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
        chartParentView.layer.cornerRadius = 25
        chartParentView.clipsToBounds = true
        chartView.frame = chartParentView.bounds
        chartParentView.addSubview(chartView)
    }
    
    func fillSummaryLabels() {
        totalIncomeAmountLabel.text = items.filter({$0.isIncome}).compactMap({Int($0.amount) ?? 0}).reduce(0, +).description + "$"
        totalSpendingAmountLabel.text = items.filter({!$0.isIncome}).compactMap({Int($0.amount) ?? 0}).reduce(0, +).description + "$"
    }
}

// MARK: - Data manager
extension TotalSummaryViewController {
    func loadChartData() {
        isTableAutoReloadEnabled = false
        items = getData()
        isTableAutoReloadEnabled = true
        let allTransactions = items.compactMap({Int($0.amount)})
        let data = AAChartModel()
            .chartType(.spline)
            .animationType(.easeInCubic)
            .dataLabelsEnabled(false)
            .touchEventEnabled(false)
            .tooltipEnabled(false)
            .legendEnabled(false)
            .markerSymbolStyle(.borderBlank)
            .colorsTheme(["#0000FF"])
            .categories(allTransactions.compactMap({$0.description}))
            .series([
                AASeriesElement()
                    .name("Expences")
                    .data(allTransactions),
//                AASeriesElement()
//                    .name("")
//                    .data(allTransactions.compactMap({$0})),
            ])
        chartView.aa_drawChartWithChartModel(data)
    }
    
    func getData() -> [TransactionData] {
        if let data = UserDefaults.standard.value(forKey:"listOfTransactions") as? Data {
            if let transferData = try? PropertyListDecoder().decode(Array<TransactionData>.self, from: data) {
                return transferData
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
