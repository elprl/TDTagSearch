//
//  TDTagSearchPresenterTests.swift
//  
//
//  Created by Paul Leo on 31/05/2022.
//

import Foundation
import Nimble
import XCTest
import Combine
@testable import TDTagSearch

public class MockInteractor: TDTagSearchInteractorPresenterInterface {
    public func fetchTagList() -> AnyPublisher<[String], Error> {
        let mockArray: [String] = ["Architecture/", "Architecture/Clean"]
        return Just(mockArray)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class TDTagSearchPresenterTests: XCTestCase {
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTagLoad() throws {
        let mockInteractor = MockInteractor()
        let viewModel = TDTagSearchViewModel()
        let presenter = TDTagSearchPresenter()
        presenter.interactor = mockInteractor
        presenter.viewModel = viewModel

        presenter.onAppear()
        expect(viewModel.tags.count).toEventually(equal(2))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
