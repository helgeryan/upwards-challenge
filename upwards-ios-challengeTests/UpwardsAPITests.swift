//
//  UpwardsAPITests.swift
//  upwards-ios-challengeTests
//
//  Created by Ryan Helgeson on 11/4/23.
//

import XCTest
import Foundation
import Combine

final class UpwardApiTests: XCTestCase {
    
    // MARK: - Setup
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    // MARK: - Teardown
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Tests
    func testAPIResponse() throws {
        var subscription: AnyCancellable? = nil
        let viewModel = TopAlbumViewModel(iTunesAPI: MockITunesAPI())
        
        XCTAssertNil(viewModel.error, "Should not have an error right away")
        XCTAssertFalse(viewModel.isLoading, "Should not be loading")
        
        // create the expectation
        let exp = expectation(description: "Loading albums")
        
        // Need to assign to a value here 
        subscription = viewModel.$albumsPublished.sink() { albums in
            // when it finishes, mark my expectation as being fulfilled
            if albums != nil {
                exp.fulfill()
            }
        }
        
        viewModel.loadData()
        
        // wait five seconds for all outstanding expectations to be fulfilled
        waitForExpectations(timeout: 5)
        
        // our expectation has been fulfilled, so we can check the result is correct
        XCTAssertEqual(viewModel.albumsPublished?.count, 10, "We should have loaded exactly 10 albums.")
        subscription?.cancel()
        subscription = nil
    }
}
