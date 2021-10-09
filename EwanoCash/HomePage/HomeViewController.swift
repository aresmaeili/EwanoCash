//
//  HomeViewController.swift
//  EwanoCash
//
//  Created by Roham on 7/7/1400 AP.
//

import UIKit
import Charts

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var listStatusLabel: UILabel!
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBAction func plusAddButton(_ sender: Any) {
        let controller = UIStoryboard(name: "Transfer", bundle: .main).instantiateViewController(withIdentifier: "TransferViewController") as! TransferViewController
        present(controller, animated: true, completion: nil)
        // loadDataFromUserDefault ()
        
    }
    
    func updateListViewForItems() {
        if item.isEmpty {
            listStatusLabel.isHidden = false
            homeTableView.isHidden = true
            homeCollectionView.isHidden = true
        } else {
            listStatusLabel.isHidden = true
            homeTableView.isHidden = false
            homeCollectionView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataFromUserDefault()
        
        
        updateListViewForItems()
        
        
        
        let df = DateFormatter()
        df.dateFormat = "MMMM-dd-yyyy"
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(identifier: "UTC")!
        
        let sortedArray = dateArray.sorted {df.date(from: $0)! < df.date(from: $1)!}
        print(sortedArray)
        
        
        
        homeTableView.reloadData()
    }
    var item = [TransfersModel]()
    var dateArray = [String]()
    var month = ["January", "February","March","April","May","June","July","August","September","October","November","December"]
    
    //var items = ["bill" , "buying shoe" , "coffee" , "taxi"]
    var monthValue : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        tabBarController?.selectedIndex = 0
        setTabBarsStyle()
        
        //        loadDataFromUserDefault()
        //        homeTableView.reloadData()
        
        homeTableView.separatorStyle = .none
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        homeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        navigationItem.title = "Home"
        
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
        UserDefaults.standard.set(try? PropertyListEncoder().encode( item ) , forKey: "listOfTransactions")
    }
    
    func loadDataFromUserDefault() {
        
        if let data = UserDefaults.standard.value(forKey:"listOfTransactions") as? Data {
            if let transferData = try? PropertyListDecoder().decode(Array<TransfersModel>.self, from: data) {
              //  print("*****************\(String(describing: transferData))")
                
                item = transferData
                
                
                
                item = item.sorted(by: { firstItem, secondItem in
                    
                    
                    let dateFormatter = DateFormatter()
                    // dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.timeStyle = DateFormatter.Style.none
                    dateFormatter.dateFormat = "YY, MMM d"
                    dateFormatter.dateStyle = DateFormatter.Style.medium
                    
                    

                    
                    
                    guard let firstDate = dateFormatter.date(from:firstItem.dateOfTransaction), let secondDate = dateFormatter.date(from: secondItem.dateOfTransaction) else { return  true }
                    print("this is firstDate\(firstDate)***********#########")
                    print("this is secondDate\(secondDate)***********#########")
                    return firstDate < secondDate
                    
                })
                //items.append(contentsOf: item)
            }
        }
        
    }
    
}





extension HomeViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return month.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        // cell.backgroundView =
        cell.monthLabel.text = month[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width / 1.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let x = scrollView.contentOffset.x
            let w = scrollView.bounds.size.width
            let currentPage = Int(ceil(x/w))
            // Do whatever with currentPage.
        print("@@@@@@@\(currentPage)")
    }
    
}

extension HomeViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        //        for _ in item[indexPath.row].dateOfTransaction {
        //            dateArray.append(item[indexPath.row].dateOfTransaction)
        //        }
        //        print("This isssssss \(dateArray)")
        
        //homeTableView.reloadData()
        
        
        
        
        
        cell.itemTitle.text = item[indexPath.row].titleOfTransaction
        cell.itemDate.text = item[indexPath.row].dateOfTransaction
        
        cell.itemPrice.text = item[indexPath.row].amountOfTransaction
        if item[indexPath.row].isIncome == true {
            cell.itemImage.image = UIImage(named: "chevron_down")
        } else {
            cell.itemImage.image = UIImage(named: "chevron_up")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            item.remove(at: indexPath.row)
            
            saveDataToUserDefault()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            updateListViewForItems()
            print(item)
        }
        return
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
