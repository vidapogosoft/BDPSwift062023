//
//  ProtocolsTutorialTests.swift
//  ProtocolsTutorialTests
//
//  Created by Victor Roldan on 4/09/21.
//

import XCTest
@testable import ProtocolsTutorial

class ProtocolsTutorialTests: XCTestCase {
    var viewModel : PostsViewModel!
    var provider : PostsProviderProtocol!
    
    override func setUpWithError() throws {
        provider = PostsProvider()
        viewModel = PostsViewModel(provider: provider)
    }

    override func tearDownWithError() throws {
        provider = nil
        viewModel = nil
    }

    func testGetUserFromProvider() throws {
        let expectation = expectation(description: "retrieving data...")
        viewModel.getUserFromProvider { postsModelArray in
            postsModelArray.forEach { object in
                print("title: ", object.title!)
            }
            XCTAssertTrue(postsModelArray.count>0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.1)
    }

}
