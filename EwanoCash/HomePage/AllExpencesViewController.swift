//
//  AllExpencesViewController.swift
//  EwanoCash
//
//  Created by Reza Kashkoul on 7/11/1400 AP.
//

import UIKit

class AllExpencesViewController: UIViewController {
    
    
    @IBOutlet weak var allExpencesTableView: UITableView!
    
    let items = ["bill" , "buying show" , "coffee" , "taxi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allExpencesTableView.delegate = self
        allExpencesTableView.dataSource = self
        navigationItem.title = "All Expences"
        allExpencesTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
    }
    
    
}

extension AllExpencesViewController : UITableViewDelegate , UITableViewDataSource {
    
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
