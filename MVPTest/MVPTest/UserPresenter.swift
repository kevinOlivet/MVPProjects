//
//  UserPresenter.swift
//  MVPTest
//
//  Created by Jon Olivet on 11/15/17.
//  Copyright © 2017 Jon Olivet. All rights reserved.
//

import Foundation

struct UserViewData{
  
  let name: String
  let age: String
}

// Does this protocol need to inherit from NSObjectProtocol instead of class?  Seems not.
// This protocol is what differintiates MVP from MVVM.  With this protocol UserPresenter knows about the View
protocol UserViewDelegate: class {
  func startLoading()
  func finishLoading()
  func setUsers(users: [UserViewData])
  func setEmptyUsers()
}

class UserPresenter {
  
  weak fileprivate var userViewDelegate: UserViewDelegate?

  fileprivate let networkService: NetworkService
  
  init(networkService:NetworkService){
    self.networkService = networkService
  }
  
  // A fancy way to set the view as the delegate. It keeps the delegate fileprivate
  func attachView(view:UserViewDelegate) {
    userViewDelegate = view
  }
  
  // A fancy way to disconnect the delegate.  This isn't called.  Is it needed?
  func detachView() {
    userViewDelegate = nil
  }
  
  // MVP in action.  Through the delegate call methods in the VC. Through the networkService access the API endpoint.
  func getUsers(){
    userViewDelegate?.startLoading()
    networkService.getUsers{ [weak self] users in
      guard let strongSelf = self else { return }
      strongSelf.userViewDelegate?.finishLoading()
      if users.count == 0 {
        strongSelf.userViewDelegate?.setEmptyUsers()
      } else {
        let mappedUsers = users.map{
          UserViewData(name: "\($0.firstName) \($0.lastName)", age: "\($0.age) years")
        }
        // Send the result to the VC through the delegate
        strongSelf.userViewDelegate?.setUsers(users: mappedUsers)
      }
      
    }
  }
}

