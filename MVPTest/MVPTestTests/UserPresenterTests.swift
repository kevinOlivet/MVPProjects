//
//  UserPresenterTests.swift
//  MVPTestTests
//
//  Created by Jon Olivet on 11/15/17.
//  Copyright © 2017 Jon Olivet. All rights reserved.
//

import XCTest
@testable import MVPTest

// These Mocks can be put inside each test if needed along with their instantiations
// Used to mock the API response
class NetworkServiceMock: NetworkService {
    fileprivate let users: [User]
    init(users: [User]) {
        self.users = users
    }
    // This override is what shorts the real network function
    override func getUsers(completion: @escaping ([User]) -> Void) {
        completion(users)
    }
}

// Used to Mock the UserViewController
// Does this class need to conform to NSObject?  Seems not.
class UserViewControllerMock: UserViewDelegate {
    var setUsersCalled = false
    var setEmptyUsersCalled = false
    
    func setUsers(users: [UserViewData]) {
        setUsersCalled = true
    }
    
    func setEmptyUsers() {
        setEmptyUsersCalled = true
    }
    
    func startLoading() {
    }
    
    func finishLoading() {
    }
}

// MARK: - Tests
class UserPresenterTest: XCTestCase {
    
    // Instantiation of mocks.  Could be put inside individual tests along with the classes declared above.
    let emptyNetworkServiceMock = NetworkServiceMock(users:[User]())
    let twoUsersServiceMock = NetworkServiceMock(users:[User(firstName: "firstname1", lastName: "lastname1", email: "first@test.com", age: 30),User(firstName: "firstname2", lastName: "lastname2", email: "second@test.com", age: 24)])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldSetEmptyIfNoUserAvailable() {
        //given
        let userViewMock = UserViewControllerMock()
        let userPresenterUnderTest = UserPresenter(networkService: emptyNetworkServiceMock)
        userPresenterUnderTest.attachView(view: userViewMock)
        
        //when
        userPresenterUnderTest.getUsers()
        
        //verify
        XCTAssertTrue(userViewMock.setEmptyUsersCalled)
    }
    
    func testShouldSetUsers() {
        //given
        let userViewMock = UserViewControllerMock()
        let userPresenterUnderTest = UserPresenter(networkService: twoUsersServiceMock)
        userPresenterUnderTest.attachView(view: userViewMock)
        
        //when
        userPresenterUnderTest.getUsers()
        
        //verify
        XCTAssertTrue(userViewMock.setUsersCalled)
    }
    
    // For if you really do want to test the network connection and not a mock.
    // You would almost certainly use a mock in real life
    func testAsynchronousURLConnection() {
        
        let url = URL(string: "https://www.apple.com/")!
        let urlExpectation = expectation(description: "GET \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            
            if let response = response as? HTTPURLResponse, let responseURL = response.url, let mimeType = response.mimeType {
                XCTAssertEqual(responseURL.absoluteString, url.absoluteString, "HTTP response URL should be equal to original URL. Maybe it's https, or you left out the www")
                XCTAssertEqual(response.statusCode, 200, "HTTP response status code should be 200")
                XCTAssertEqual(mimeType, "text/html", "HTTP response content type should be text/html")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
            urlExpectation.fulfill()
        }
        task.resume()
        
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
    
    // Again you would really use a mock for this
    func testNetworkServiceAsynchronousResponse() {
        // expectation declared
        let networkServiceExpectation = expectation(description: "Should return the users asynchronously")
        
        let networkService = NetworkService()
        networkService.getUsers { (users) in
            print(users)
            // expectation fullfilled
            networkServiceExpectation.fulfill()
        }
        // wait for expectation
        waitForExpectations(timeout: 3) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
