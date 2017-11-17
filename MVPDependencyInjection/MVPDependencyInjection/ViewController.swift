//
//  ViewController.swift
//  UnitTestsDependencyInjection
//
//  Created by Jon Olivet on 11/15/17.
//  Copyright © 2017 Jon Olivet. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let minionPresenter = MinionPresenter(minionService: MinionService())
    var dataSource: [Minion]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minionPresenter.attachView(view: self)
        minionPresenter.fetchMinions()
    }
    
    // MARK: - TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "minionCell", for: indexPath)
        if let minion = dataSource?[indexPath.row] {
            cell.textLabel?.text = minion.name
            cell.imageView?.image = UIImage(named: minion.name)
        }
        
        return cell
    }
    
}

// MARK: - MinionViewDelegate
extension ViewController: MinionViewDelegate {
    
    func setMinions(minions: [Minion]) {
        dataSource = minions
        tableView.reloadData()
    }
    
    func setEmptyMinions(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
