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
        let mockArray: [String] = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        return Just(mockArray)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class TDTagSearchPresenterTests: XCTestCase {

    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }

    func testOnAppear() throws {
        let mockInteractor = MockInteractor()
        let viewModel = TDTagSearchViewModel()
        let presenter = TDTagSearchPresenter()
        presenter.interactor = mockInteractor
        presenter.viewModel = viewModel

        presenter.onAppear()
        expect(viewModel.tags.count).toEventually(equal(3))
    }
    
    func testOnTappingTag() throws {
        let mockInteractor = MockInteractor()
        let viewModel = TDTagSearchViewModel()
        let presenter = TDTagSearchPresenter()
        presenter.interactor = mockInteractor
        presenter.viewModel = viewModel

        viewModel.tags = ["Architecture/", "Architecture/Clean"]
        let folderTag = "Architecture/"
        presenter.onTap(tag: folderTag)
        expect(viewModel.selectedPath).to(equal(folderTag))
        expect(viewModel.filteredTags.count).to(equal(1))
        expect(viewModel.selectedTags.count).to(equal(0))
        
        let selectableTag = "Architecture/Clean"
        presenter.onTap(tag: selectableTag)
        expect(viewModel.selectedPath).to(equal(folderTag))
        expect(viewModel.filteredTags.count).to(equal(1))
        expect(viewModel.selectedTags.count).to(equal(1))
    }
    
    func testOnBackUpTheTree() throws {
        let mockInteractor = MockInteractor()
        let viewModel = TDTagSearchViewModel()
        let presenter = TDTagSearchPresenter()
        presenter.interactor = mockInteractor
        presenter.viewModel = viewModel

        viewModel.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        viewModel.selectedPath = "Architecture/"
        presenter.onBack()
        expect(viewModel.selectedPath).to(beNil())
        expect(viewModel.filteredTags.count).to(equal(1))
        
        viewModel.selectedPath = "Architecture/Clean/"
        presenter.onBack()
        expect(viewModel.selectedPath).to(equal("Architecture/"))
        expect(viewModel.filteredTags.count).to(equal(1))
    }
    
    func testOnDeselectTag() throws {
        let mockInteractor = MockInteractor()
        let viewModel = TDTagSearchViewModel()
        let presenter = TDTagSearchPresenter()
        presenter.interactor = mockInteractor
        presenter.viewModel = viewModel

        viewModel.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        viewModel.selectedTags = ["Architecture/Clean/Interface"]
        presenter.onDismiss(tag: "Architecture/Clean/Interface")
        expect(viewModel.selectedTags.count).to(equal(0))
    }
    
    func testOnCancelSearch() throws {
        let mockInteractor = MockInteractor()
        let viewModel = TDTagSearchViewModel()
        let presenter = TDTagSearchPresenter()
        presenter.interactor = mockInteractor
        presenter.viewModel = viewModel

        viewModel.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        viewModel.searchText = "Arc"
        viewModel.filteredTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        presenter.onCancelSearch()
        expect(viewModel.filteredTags.count).to(equal(1))
    }
    
    func testOnSave() throws {
        let mockInteractor = MockInteractor()
        let viewModel = TDTagSearchViewModel()
        let presenter = TDTagSearchPresenter()
        presenter.interactor = mockInteractor
        presenter.viewModel = viewModel

        viewModel.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        viewModel.selectedTags = ["Architecture/Clean/Interface"]
        presenter.onSave(tags: ["Architecture/Clean/Interface"])
        expect(viewModel.selectedTags.count).to(equal(1))
        expect(viewModel.hasFinished).to(beTrue())
    }

    func testSearch() throws {
        let mockInteractor = MockInteractor()
        let viewModel = TDTagSearchViewModel()
        let presenter = TDTagSearchPresenter()
        presenter.interactor = mockInteractor
        presenter.viewModel = viewModel
        presenter.onAppear()

//        viewModel.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        viewModel.searchText = ""
        expect(viewModel.filteredTags.count).toEventually(equal(1))
        expect(viewModel.filteredTags).toEventually(contain("Architecture/"))

        let tag = "Architecture/Clean/Interface"
        viewModel.searchText = "arch"
        expect(viewModel.filteredTags).toEventually(contain(tag))
        expect(viewModel.filteredTags.count).toEventually(equal(3))
        
//        viewModel.searchText = tag
//        expect(viewModel.filteredTags).toEventually(contain(tag))
//        expect(viewModel.filteredTags.count).toEventually(equal(1))
    }
}
