//
//  HomeViewController.swift
//  EwanoCash
//
//  Created by Roham on 7/7/1400 AP.
//

import UIKit

class HomeViewController: UIViewController{

    
    
    @IBOutlet weak var homeChartLabel: UILabel!
    @IBOutlet weak var homeTableView: UITableView!
    
    
    let items = ["bill" , "buying show" , "coffee" , "taxi"]
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeChartLabel.layer.cornerRadius = 25
        homeChartLabel.clipsToBounds = true


        
        
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
}

