//
//  NetworkService.swift
//  MVPTest
//
//  Created by Jon Olivet on 11/15/17.
//  Copyright © 2017 Jon Olivet. All rights reserved.
//

import Foundation

class NetworkService {
  
  // The service delivers mocked data with a delay, in real life it would be a network call probably.
  // The mock for the test is in UserPresenterTests.swift.  It overrides func getUsers
  func getUsers(completion: @escaping ([User]) -> Void){
    let users = [User(firstName: "Jon", lastName: "Olivet", email: "jon@test.com", age: 36),
                 User(firstName: "Kevin", lastName: "Olivet", email: "kevin@test.om", age: 24),
                 User(firstName: "Max", lastName: "Boulat", email: "max@test.com", age: 39)
    ]
    let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      completion(users)
    }
  }
}

