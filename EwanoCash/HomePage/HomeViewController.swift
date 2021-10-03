//
//  HomeViewController.swift
//  EwanoCash
//
//  Created by Roham on 7/7/1400 AP.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    
    @IBOutlet weak var homeChartView: UIView!
    
    @IBOutlet weak var homeTableView: UITableView!
    
    @IBAction func plusAddButton(_ sender: Any) {
    }
    
    let items = ["bill" , "buying show" , "coffee" , "taxi"]
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        
        
        
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        navigationItem.title = "Month Of June"
        
        
        
        
        homeChartView.layer.cornerRadius = 25
        homeChartView.clipsToBounds = true
        
        
        
        
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
