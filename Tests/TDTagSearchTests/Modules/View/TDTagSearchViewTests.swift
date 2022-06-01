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
        func onAppear() { }
        func onDisappear() { }
        func onSave(tags: [String]) { }
        func onTap(tag: String) { }
        func onDismiss(tag: String) { }
        func onBack() { }
        func onCancelSearch() { }
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
}
