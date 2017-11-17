//
//  ViewControllerTests.swift
//  MVPDependencyInjectionTests
//
//  Created by Jon Olivet on 11/16/17.
//  Copyright © 2017 Jon Olivet. All rights reserved.
//

import XCTest
@testable import MVPDependencyInjection

class ViewControllerTests: XCTestCase {
    
    // These Mocks can be put inside each test if needed along with their instantiations
    // Used to mock the API response
    class MockMinionService: MinionService {
        var getTheMinionsWasCalled = false
        var result = [Minion(name: "Bob"), Minion(name: "Dave")]
        
        // This override is what shorts the real network function
        override func getTheMinions(completionHandler: @escaping (MinionDataResult) -> Void) {
            getTheMinionsWasCalled = true
            completionHandler(MinionDataResult.success(result))
        }
    }
    
    // This Mock gives an error and empty data
    class MockEmptyMinionService: MinionService {
        var getTheMinionsWasCalled = false
        let error = NSError(domain: "Error", code: 400, userInfo: [NSLocalizedDescriptionKey : "Oops! The Minions are missing on a new fun adventure!"])
        
        // This override is what shorts the real network function
        override func getTheMinions(completionHandler: @escaping (MinionDataResult) -> Void) {
            getTheMinionsWasCalled = true
            completionHandler(MinionDataResult.failure(error))
        }
    }
    
    // Used to Mock the ViewController
    class MockViewController: MinionViewDelegate {
        var setMinionsCalled = false
        var setEmptyMinionsCalled = false
        var dataSource: [Minion]?
        
        func setMinions(minions: [Minion]) {
            setMinionsCalled = true
            dataSource = minions
        }
        
        func setEmptyMinions(message: String) {
            setEmptyMinionsCalled = true
        }
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests
    func testFetchMinionsFromMockViewController() {
        //given
        let mockViewController = MockViewController()
        let mockMinionService = MockMinionService()
        let minionPresenterUnderTest = MinionPresenter(minionService: mockMinionService)
        let expectedResult = [Minion(name: "Bob"), Minion(name: "Dave")]
        
        //when
        minionPresenterUnderTest.attachView(view: mockViewController)
        minionPresenterUnderTest.fetchMinions(minionService: mockMinionService)
        
        //verify
        XCTAssertTrue(mockMinionService.getTheMinionsWasCalled)
        XCTAssertTrue(mockViewController.setMinionsCalled)
        
        XCTAssertEqual(mockMinionService.result, expectedResult, "result should be the same.")
        XCTAssertEqual(mockViewController.dataSource!, expectedResult, "result should be the same.")
        
    }
    
    func testFetchMinionsFromMockViewControllerError() {
        //given
        let mockViewController = MockViewController()
        let mockEmptyMinionService = MockEmptyMinionService()
        let minionPresenterUnderTest = MinionPresenter(minionService: mockEmptyMinionService)
        let expectedError = NSError(domain: "Error", code: 400, userInfo: [NSLocalizedDescriptionKey : "Oops! The Minions are missing on a new fun adventure!"])
        
        //when
        minionPresenterUnderTest.attachView(view: mockViewController)
        minionPresenterUnderTest.fetchMinions(minionService: mockEmptyMinionService)
        
        //verify
        XCTAssertTrue(mockEmptyMinionService.getTheMinionsWasCalled)
        XCTAssertTrue(mockViewController.setEmptyMinionsCalled)
        
        XCTAssertEqual(mockEmptyMinionService.error, expectedError)
        XCTAssertNil(mockViewController.dataSource)
    }
    
}
