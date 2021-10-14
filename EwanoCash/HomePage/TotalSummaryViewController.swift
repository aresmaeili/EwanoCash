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
    var items: [TransfersModel] = [] {
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
        chartParentView.layer.cornerRadius = 10
        chartParentView.clipsToBounds = true
        chartView.frame = chartParentView.bounds
        chartParentView.addSubview(chartView)
        chartView.layer.position.x -= 5
    }
    
    func fillSummaryLabels() {
        totalIncomeAmountLabel.text = items.filter({$0.isIncome}).compactMap({Int($0.amountOfTransaction) ?? 0}).reduce(0, +).description + "$"
        totalSpendingAmountLabel.text = items.filter({!$0.isIncome}).compactMap({Int($0.amountOfTransaction) ?? 0}).reduce(0, +).description + "$"
    }
}

// MARK: - Data manager
extension TotalSummaryViewController {
    
    func loadChartData() {
        let gradientColor = AAGradientColor.linearGradient(direction: .toBottom, startColor: "#0000ffff", endColor: "#ffffff00")
        isTableAutoReloadEnabled = false
        items = getData()
        isTableAutoReloadEnabled = true
        let allTransactions = items.compactMap({Int($0.amountOfTransaction)})
        let data = AAChartModel()
        //            .markerRadius(0) // MARK: For Hiding points on the chart
            .chartType(.areaspline)
            .animationType(.easeInCubic)
            .dataLabelsEnabled(false)
            .touchEventEnabled(false)
            .tooltipEnabled(true)
            .legendEnabled(false)
            .dataLabelsEnabled(true)
            .markerSymbolStyle(.borderBlank)
            .colorsTheme(["#0000FF"])
            .categories(allTransactions.compactMap({$0.description}))
            .series([
                AASeriesElement()
                    .name("Day")
                    .data(allTransactions)
                .color(gradientColor),
//                AASeriesElement()
//                    .name("")
//                    .data(allTransactions.compactMap({$0})),
            ])
        chartView.aa_drawChartWithChartModel(data)
    }
    
    func getData()-> [TransfersModel] {
        if let data = UserDefaults.standard.value(forKey:"listOfTransactions") as? Data {
            if let transferData = try? PropertyListDecoder().decode(Array<TransfersModel>.self, from: data) {
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
        let item = items[indexPath.row]
        cell.itemTitle.text = item.titleOfTransaction
        cell.itemDate.text = item.dateOfTransaction.getPrettyDate()
        cell.itemPrice.text = item.amountOfTransaction
        if item.isIncome == true {
            cell.itemImage.image = UIImage(named: "chevron_down")
        } else {
            cell.itemImage.image = UIImage(named: "chevron_up")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
