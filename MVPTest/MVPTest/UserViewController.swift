//
//  UserViewController.swift
//  MVPTest
//
//  Created by Jon Olivet on 11/15/17.
//  Copyright © 2017 Jon Olivet. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource {

  fileprivate let userPresenter = UserPresenter(networkService: NetworkService())
  fileprivate var usersToDisplay = [UserViewData]()
  
  @IBOutlet weak var emptyView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView?.dataSource = self
    activityIndicator?.hidesWhenStopped = true
    
    userPresenter.attachView(view: self)
    userPresenter.getUsers()
  }
  
  // MARK: - TableView Methods
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usersToDisplay.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
    let userViewData = usersToDisplay[indexPath.row]
    cell.textLabel?.text = userViewData.name
    cell.detailTextLabel?.text = userViewData.age
    return cell
  }
  
}

// MARK: - UserViewDelegate
extension UserViewController: UserViewDelegate {
  
  func startLoading() {
    activityIndicator?.startAnimating()
  }
  
  func finishLoading() {
    activityIndicator?.stopAnimating()
  }
  
  func setUsers(users: [UserViewData]) {
    usersToDisplay = users
    tableView?.isHidden = false
    emptyView?.isHidden = true
    tableView?.reloadData()
  }
  
  func setEmptyUsers() {
    tableView?.isHidden = true
    emptyView?.isHidden = false
  }
  
}

