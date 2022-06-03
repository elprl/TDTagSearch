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

    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }

    func testFetchTagList() throws {
        let interactor = TDTagSearchInteractor()
        var myTags: [String] = []
        interactor.fetchTagList()
            .sink { completion in
                switch completion {
                case .finished: print("🏁 finished")
                case .failure(let error): print("❗️ failure: \(error)")
                }
            } receiveValue: { tags in
                myTags = tags
            }
            .store(in: &cancellables)
        
        expect(myTags.count).toEventually(beGreaterThan(0))
    }
    
    func testFetchError() throws {
        let interactor = TDTagSearchInteractor()
        var myTags: [String] = []
        interactor.fetchTagList()
            .sink { completion in
                switch completion {
                case .finished:
                    print("🏁 finished")
                case .failure(let error as NSError):
                    expect(error).toNot(beNil())
                    expect(error.code).to(equal(400))
                    expect(error.domain).to(equal("Error: Failed to load tags from file"))
                }
            } receiveValue: { tags in
                myTags = tags
            }
            .store(in: &cancellables)
        expect(myTags).toEventually(beEmpty())
    }
}
