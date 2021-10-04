//
//  HomeViewController.swift
//  EwanoCash
//
//  Created by Roham on 7/7/1400 AP.
//

import UIKit
import Charts

class HomeViewController: UIViewController {
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBAction func plusAddButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeTableView.separatorStyle = .none
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        homeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        navigationItem.title = "Home"
        
    }
}


var month = ["April" , "June"]
var items = ["bill" , "buying shoe" , "coffee" , "taxi"]


extension HomeViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return month.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        // cell.backgroundView =
        
        
        //cell.layer.cornerRadius = 25
        // cell.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width-70
        return CGSize(width: width, height: width / 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
    }
}

extension HomeViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.itemTitle.text = items[indexPath.row]
        //        cell?.itemImage.image =
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
