//
//  MinionService.swift
//  UnitTestsDependencyInjection
//
//  Created by Jon Olivet on 11/15/17.
//  Copyright © 2017 Jon Olivet. All rights reserved.
//

import Foundation

class MinionService {
    
    enum MinionDataResult {
        case success([Minion])
        case failure(NSError)
    }
    
    //Change chosenResult if you want to test error scenario
    enum ChooseResult {
        case success, error
    }
    let chosenResult: ChooseResult = .success
    
    func getTheMinions(completionHandler: @escaping (MinionDataResult) -> Void) {
        print("Pretend we're getting minions asynchronously")
        
        if chosenResult == .success {
            let minionData = [Minion(name: "Bob"), Minion(name: "Dave")]
            DispatchQueue.main.async {
                completionHandler(MinionDataResult.success(minionData))
            }
        } else {
            let error = NSError(domain: "Error", code: 400, userInfo: [NSLocalizedDescriptionKey : "Oops! The Minions are missing on a new fun adventure!"])
            completionHandler(MinionDataResult.failure(error))
        }
    }
    
}

