//
//  HomeViewController.swift
//  EwanoCash
//
//  Created by Roham on 7/7/1400 AP.
//

import UIKit
import AAInfographics

class HomeViewController: UIViewController {
    
    @IBOutlet weak var listStatusLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func plusAddButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TransferViewController") as! TransferViewController
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    var dateArray = [String]()
    var month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var monthValue : String = ""
    var isTableAutoReloadEnabled = true
    var allItems: [TransfersModel] = []
    var items: [TransfersModel] = [] {
        didSet {
            if isTableAutoReloadEnabled {
                DispatchQueue.main.async { [self] in
                    makeOutcomesNegetive()
                    updateListViewForItems()
                    tableView.reloadData()
                    collectionView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        tabBarController?.selectedIndex = 0
        tableView.separatorStyle = .none
        setTabBarsStyle()
        loadData()
//        sortDates()
    }
    
    func loadData() {
        allItems = getDataFromUserDefault()
        items = allItems
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
    
    func saveDataToUserDefault() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode( items ) , forKey: "listOfTransactions")
    }
    
    func getDataFromUserDefault()-> [TransfersModel] {
        if let data = UserDefaults.standard.value(forKey:"listOfTransactions") as? Data {
            if let transferData = try? PropertyListDecoder().decode(Array<TransfersModel>.self, from: data) {
                print("*****************\(String(describing: transferData))")
                return transferData
            }
        }
        return []
    }
    
    func getChartData(for month: String)-> AAChartModel {
        isTableAutoReloadEnabled = false
        items = allItems.filter({$0.dateOfTransaction.getStringMonth().lowercased() == month.lowercased()}).sorted(by:{$0.dateOfTransaction.get(.day) < $1.dateOfTransaction.get(.day)})
        isTableAutoReloadEnabled = true
        var balance = 0
        var allTransactions:[Int] = []
        for i in 0...31 {
            if items.compactMap({$0.dateOfTransaction.get(.day)}).contains(i) {
                for j in 0..<items.count {
                    if items[j].dateOfTransaction.get(.day) == i { // transaction in day of i
                        balance = balance + Int(items[j].amountOfTransaction)!
                        allTransactions.append(balance)
                    }
                }
            } else {
                allTransactions.append(balance) // MARK: Not sure about that
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
    
    func updateListViewForItems() {
        if items.isEmpty {
            listStatusLabel.isHidden = false
        } else {
            listStatusLabel.isHidden = true
        }
    }
    
    func getDaysNumberOfMonth(dateString: String)-> Int {
        let date = dateString.toDate()!
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let days = cal.range(of: .day, in: .month, for: date)
        return days.hashValue
    }
    
    func makeOutcomesNegetive() {
        for i in 0..<items.count {
            if !items[i].isIncome {
                if Int(items[i].amountOfTransaction)! > 0 {
                    items[i].amountOfTransaction = (Int(items[i].amountOfTransaction)! * -1).description
                }
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return month.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.monthLabel.text = month[indexPath.row]
        DispatchQueue.main.async { [self] in
            cell.fill(with: getChartData(for: month[indexPath.row]))
        }
        return cell
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
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        if items.isEmpty { return cell }
        let item = items[indexPath.row]
        cell.itemTitle.text = item.titleOfTransaction
        cell.itemDate.text = item.dateOfTransaction.description
        cell.itemPrice.text = item.amountOfTransaction
        if item.isIncome == true {
            cell.itemImage.image = UIImage(named: "chevron_down")
        } else {
            cell.itemImage.image = UIImage(named: "chevron_up")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            items.remove(at: indexPath.row)
            saveDataToUserDefault()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        return
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension HomeViewController: TransferViewControllerDelegate {
    
    func insertedNewData() {
        allItems = getDataFromUserDefault()
        items = allItems
    }
}

extension Date {
 
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func getStringMonth() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM")
        return df.string(from: self)
    }
}
