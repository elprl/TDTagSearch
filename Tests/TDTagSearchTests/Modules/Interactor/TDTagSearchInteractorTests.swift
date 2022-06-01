//
//  TDTagSearchInteractorTests.swift
//  
//
//  Created by Paul Leo on 01/06/2022.
//

import XCTest
import Nimble
import Combine
@testable import TDTagSearch

class TDTagSearchInteractorTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []

    public class MockPresenter: TDTagSearchPresenterInteractorInterface {
        
    }

    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }

    func testFetchTagList() throws {
        let interactor = TDTagSearchInteractor()
        interactor.fetchTagList(path: Bundle.module.path(forResource: "tags", ofType: "json"))
            .sink { state in
                debugPrint(state)
            } receiveValue: { tags in
                expect(tags.count).to(beGreaterThan(0))
            }
            .store(in: &cancellables)
    }

}
