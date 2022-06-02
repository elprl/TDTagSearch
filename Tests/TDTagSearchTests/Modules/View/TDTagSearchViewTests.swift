//
//  TDTagSearchViewTests.swift
//  
//
//  Created by Paul Leo on 01/06/2022.
//

import Foundation
import Nimble
import XCTest
import Combine
import SwiftUI
import ViewInspector
@testable import TDTagSearch

extension TDTagSearchSUI: Inspectable { }
extension TDTagSearchScrollViewSUI: Inspectable { }
extension TDTagViewSUI: Inspectable { }
extension TDTagCapsuleSUI: Inspectable { }

class TDTagSearchViewTests: XCTestCase {
    
    class MockPresenter: TDTagSearchPresenterViewInterface {
        var didCallOnAppear: Bool = false
        var didCallOnDisappear: Bool = false
        var didCallOnSave: Bool = false
        var didCallOnTap: Bool = false
        var didCallOnDismiss: Bool = false
        var didCallOnBack: Bool = false
        var didCallOnCancelSearch: Bool = false
        
        func onAppear() { didCallOnAppear.toggle() }
        func onDisappear() { didCallOnDisappear.toggle() }
        func onSave(tags: [String]) { didCallOnSave.toggle() }
        func onTap(tag: String) { didCallOnTap.toggle() }
        func onDismiss(tag: String) { didCallOnDismiss.toggle() }
        func onBack() { didCallOnBack.toggle() }
        func onCancelSearch() { didCallOnCancelSearch.toggle() }
    }

    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }

    func testSelectedTags() throws {
        let vm = TDTagSearchViewModel()
        vm.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.selectedTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.filteredTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        let sut = TDTagSearchSUI(presenter: MockPresenter(), viewModel: vm)
        let firstSelectedTagText = try sut.inspect().find(viewWithTag: "selectedTags").find(TDTagCapsuleSUI.self).find(text: "Architecture").string()
        debugPrint(firstSelectedTagText)
        expect(firstSelectedTagText).toEventually(equal("Architecture"))
    }
    
    func testFilteredTags() throws {
        let vm = TDTagSearchViewModel()
        vm.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.selectedTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.filteredTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        let sut = TDTagSearchSUI(presenter: MockPresenter(), viewModel: vm)
        
        let firstFilteredTagText = try sut.inspect().find(viewWithTag: "filteredTags").find(TDTagCapsuleSUI.self).find(text: "Architecture").string()
        debugPrint(firstFilteredTagText)
        expect(firstFilteredTagText).toEventually(equal("Architecture"))
    }

    func testSectionLabel() throws {
        let vm = TDTagSearchViewModel()
        vm.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.selectedTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.filteredTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        let sut = TDTagSearchSUI(presenter: MockPresenter(), viewModel: vm)
        let firstSelectedTagText = try sut.inspect().find(viewWithTag: "sectionLabel").text().string()
        debugPrint(firstSelectedTagText)
        expect(firstSelectedTagText).toEventually(equal("Selected Tags:"))
    }
    
    func testOnAppear() throws {
        let vm = TDTagSearchViewModel()
        vm.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.selectedTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.filteredTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        let presenter = MockPresenter()
        let sut = TDTagSearchSUI(presenter: presenter, viewModel: vm)
        ViewHosting.host(view: sut)
        expect(presenter.didCallOnAppear).toEventually(beTrue())
    }
    
    func testOnSave() throws {
        let vm = TDTagSearchViewModel()
        vm.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.selectedTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.filteredTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        let presenter = MockPresenter()
        let sut = TDTagSearchSUI(presenter: presenter, viewModel: vm)
        let _ = try sut.inspect().find(button: "Save").tap()
        ViewHosting.host(view: sut)
        expect(presenter.didCallOnSave).toEventually(beTrue())
    }
    
    func testOnTagTapped() throws {
        let vm = TDTagSearchViewModel()
        vm.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.selectedTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.filteredTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        let presenter = MockPresenter()
        let sut = TDTagSearchSUI(presenter: presenter, viewModel: vm)
        let _ = try sut.inspect().find(button: "Architecture").tap()
        ViewHosting.host(view: sut)
        expect(presenter.didCallOnTap).toEventually(beTrue())
    }
    
    func testOnBackTapped() throws {
        let vm = TDTagSearchViewModel()
        vm.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.selectedPath = "Architecture/Clean/"
        vm.selectedTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.filteredTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        let presenter = MockPresenter()
        let sut = TDTagSearchSUI(presenter: presenter, viewModel: vm)
        let _ = try sut.inspect().find(button: "< Back").tap()
        ViewHosting.host(view: sut)
        expect(presenter.didCallOnBack).toEventually(beTrue())
    }
    
    func testOnCancelSearch() throws {
        let vm = TDTagSearchViewModel()
        vm.tags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.searchText = "Arch"
        vm.selectedTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        vm.filteredTags = ["Architecture/", "Architecture/Clean/", "Architecture/Clean/Interface"]
        let presenter = MockPresenter()
        let sut = TDTagSearchSUI(presenter: presenter, viewModel: vm)
//        let _ = try sut.inspect().find(button: "< Back").tap()
        ViewHosting.host(view: sut)
        vm.searchText = ""
        expect(presenter.didCallOnCancelSearch).toEventually(beTrue())
    }
}
