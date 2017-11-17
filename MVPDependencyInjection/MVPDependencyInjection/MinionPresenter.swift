//
//  MinionPresenter.swift
//  MVPDependencyInjection
//
//  Created by Jon Olivet on 11/16/17.
//  Copyright © 2017 Jon Olivet. All rights reserved.
//

import UIKit

protocol MinionViewDelegate: class {
    func setMinions(minions: [Minion])
    func setEmptyMinions(message: String)
}

class MinionPresenter {
    weak fileprivate var minionViewDelegate: MinionViewDelegate?
    
    fileprivate let minionService: MinionService
    
    init(minionService: MinionService) {
        self.minionService = minionService
    }
    
    func attachView(view: MinionViewDelegate) {
        minionViewDelegate = view
    }
    
    func detachView() {
        minionViewDelegate = nil
    }
    
    func fetchMinions(minionService: MinionService = MinionService()) {
        minionService.getTheMinions { [unowned self] (minionDataResult) in
            switch (minionDataResult) {
            case .success(let minionsData):
                self.minionViewDelegate?.setMinions(minions: minionsData)
            case .failure(let error):
                self.minionViewDelegate?.setEmptyMinions(message: error.localizedDescription)
            }
        }
    }
    
}
