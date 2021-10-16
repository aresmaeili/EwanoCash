//
//  HomeViewController.swift
//  EwanoCash
//
//  Created by Roham on 7/7/1400 AP.
//

import UIKit
import AAInfographics

var yearArray: [Int]!
var currentYear = Date().get(.year)
var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func plusAddButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TransferViewController") as! TransferViewController
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    var isCollectionViewScrolledToCurrentMonth = false
    var monthValue : String = ""
    var isTableAutoReloadEnabled = true
    var allItems: [TransactionData] = []
    var items: [TransactionData] {
        get {
            return getData(of: collectionView.indexPathsForVisibleItems.first)
        }
        set {
            if isTableAutoReloadEnabled {
                DispatchQueue.main.async { [self] in
                    updateListViewForItems()
                    collectionView.reloadData()
                    if !isCollectionViewScrolledToCurrentMonth {
                        collectionView.scrollToItem(at: IndexPath(row: Date().get(.month)-1, section: 0), at: .centeredVertically, animated: true)
                        isCollectionViewScrolledToCurrentMonth = true
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        yearArray = Array(1980...currentYear)
        navigationItem.title = "Home"
        setupTableView()
        setupCollectionView()
        addYearButtonToNavigationBar()
        setTabBarsStyle()
        loadData()
        
        collectionView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func loadData() {
        navigationItem.leftBarButtonItem?.title = currentYear.description
        allItems = DataManager.shared.transactions
        items = getData(of: collectionView.indexPathsForVisibleItems.first)
        collectionView.scrollToItem(at: IndexPath(row: Date().get(.month), section: 0), at: .left, animated: true)
        
    }
    
    func setTabBarsStyle() {
        tabBarController?.tabBar.items![0].image = UIImage(named: "home")
        tabBarController?.tabBar.items![0].selectedImage = UIImage(named: "home_filled")
        tabBarController?.tabBar.items![0].title = "Home"
        tabBarController?.tabBar.items![1].image = UIImage(named: "expense")
        tabBarController?.tabBar.items![1].selectedImage = UIImage(named: "expense_filled")
        tabBarController?.tabBar.items![1].title = "Expences"
        tabBarController?.tabBar.items![2].image = UIImage(named: "total")
        tabBarController?.tabBar.items![2].selectedImage = UIImage(named: "total_filled")
        tabBarController?.tabBar.items![2].title = "Total"
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func setupCollectionView() {
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func addYearButtonToNavigationBar() {
        let butt = UIBarButtonItem(title: currentYear.description, style: .plain, target: self, action: #selector(navigationYearButtonAction))
        navigationItem.leftBarButtonItem = butt
    }
    
    @objc func navigationYearButtonAction() {
        showYearAlertPicker()
    }

    func getChartData(for path: IndexPath?) -> AAChartModel {
        var balance: Int = 0
        var allTransactions: [Int] = []
        for i in 0...31 {
            if items.compactMap({$0.date.get(.year)}).contains(currentYear) {
                if items.compactMap({$0.date.get(.day)}).contains(i) {
                    for j in 0..<items.count {
                        if items[j].date.get(.day) == i { // transaction in day of i
                            balance = balance + items[j].amount
                            allTransactions.append(balance)
                        }
                    }
                } else {
                    allTransactions.append(balance) // MARK: Not sure about that
                }
            }
        }
        //        let gradientColor = AAGradientColor.linearGradient(
        //            direction: .toBottomRight,
        //            startColor: "#0000FF",
        //            endColor: "#fffff")
        let data = AAChartModel()
            .chartType(.spline)
            .animationType(.easeInCubic)
            .dataLabelsEnabled(false) //Enable or disable the data labels. Defaults to false
            .touchEventEnabled(false)
            .tooltipEnabled(false)
            .legendEnabled(false)
            .markerSymbolStyle(.borderBlank)
            .colorsTheme(["#0000FF", "#00000000"])
            .categories(Array(1...31).compactMap({$0.description}))
            .series([
                AASeriesElement()
                    .name("Expences")
                    .data(allTransactions),
                //                    .color(gradientColor),
                AASeriesElement()
                    .name("")
                    .data(Array(1...31).compactMap({$0})),
            ])
        return data
    }
    
    func getData(of path: IndexPath?)-> [TransactionData] {
        #warning("")
        if let indexPath = path,
           months.indices.contains(indexPath.row) {
            let month: String = months[indexPath.row]
            let items = allItems.filter({$0.date.getStringMonth().lowercased() == month.lowercased()}).sorted(by:{$0.date.get(.day) < $1.date.get(.day)})
            return items
        } else {
            return []
        }
    }
    
    func updateListViewForItems() {
        if items.isEmpty {
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: tableView.frame.width - 32, height: 30)
            label.center = tableView.center
            label.font = .systemFont(ofSize: 19, weight: .bold)
            label.text = "There's no Entry"
            label.textColor = .systemBlue
            label.textAlignment = .center
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }
    
    func getDaysNumberOfMonth(dateString: String)-> Int {
        let date = dateString.toDate()!
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let days = cal.range(of: .day, in: .month, for: date)
        return days.hashValue
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        if months.indices.contains(indexPath.row) {
            let cellData = months[indexPath.row]
            cell.monthLabel.text = cellData
            DispatchQueue.main.async { [self] in
                cell.fill(with: getChartData(for: indexPath))
            }
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                items = getData(of: collectionView.indexPathsForVisibleItems.first)
                tableView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: width / 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}

extension HomeViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateListViewForItems()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if items.indices.contains(indexPath.row) {
                if let index = allItems.firstIndex(where: {$0 == items[indexPath.row]}) {
                    allItems.remove(at: index)
                    DataManager.shared.transactions = allItems
                    items = getData(of: collectionView.indexPathsForVisibleItems.first)
                    tableView.reloadData()
                }
            }
        }
        return
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension HomeViewController: UIPickerViewDataSource, UIPickerViewDelegate {

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

extension HomeViewController: TransferViewControllerDelegate {
    func insertedNewData(item: TransactionData) {
        allItems = DataManager.shared.transactions
        allItems.append(item)
        DataManager.shared.transactions = allItems
        items = getData(of: collectionView.indexPathsForVisibleItems.first)
        tableView.reloadData()
    }
}
