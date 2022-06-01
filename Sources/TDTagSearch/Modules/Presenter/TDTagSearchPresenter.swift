//
//  TDTagSearchPresenter.swift
//  TDTagSearch
//
//  Created by Paul Leo on 26/05/2022.
//

import Foundation
import Combine

protocol TDTagSearchPresenterViewInterface: AnyObject {
    func onAppear()
    func onDisappear()
    func onSave(tags: [String])
    func onTap(tag: String)
    func onDismiss(tag: String)
    func onBack()
    func onCancelSearch()
}

#if DEBUG
class MockPresenter: TDTagSearchPresenterViewInterface {
    func onAppear() { }
    func onDisappear() { }
    func onSave(tags: [String]) { }
    func onTap(tag: String) { }
    func onDismiss(tag: String) { }
    func onBack() { }
    func onCancelSearch() { }
}
#endif

protocol TDTagSearchPresenterInteractorInterface: AnyObject {

}

final public class TDTagSearchPresenter {
    var interactor: TDTagSearchInteractorPresenterInterface!
    weak var viewModel: TDTagSearchViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    private func searchFilter(_ tag: String) -> Bool {
        if self.viewModel.searchText.isEmpty { return false }
        if tag.lowercased().contains(self.viewModel.searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) { return true }
        return false
    }
    
    private func treeFilter(_ tag: String) -> Bool {
        if let path = self.viewModel.selectedPath {
            if tag == path { return false }
            if !tag.lowercased().contains(path.lowercased()) { return false }
            let pathSubStrings = path.components(separatedBy: "/")
            let tagSubStrings = tag.components(separatedBy: "/")
            if tag.hasSuffix("/") {
                if (tagSubStrings.count - pathSubStrings.count) >= 2 { return false }
            } else {
                if (tagSubStrings.count - pathSubStrings.count) >= 1 { return false }
            }
            return true
        } else {
            if tag.hasSuffix("/") && tag.components(separatedBy: "/").count == 2 { return true }
        }
        return false
    }
}

extension TDTagSearchPresenter: TDTagSearchPresenterViewInterface {
    func onAppear() {
        self.interactor.fetchTagList(path: Bundle.module.path(forResource: "tags", ofType: "json"))
            .subscribe(on: DispatchQueue.global(qos: .background))
            .compactMap({ tags -> ([String], [String]) in
                return (tags, tags.filter(self.treeFilter))
            })
            .receive(on: DispatchQueue.main)
            .sink { error in
                // handle error
                print("completion with \(error)")
            } receiveValue: { tags, filteredTags in
                self.viewModel.tags = tags
                self.viewModel.filteredTags = filteredTags
            }
            .store(in: &cancellables)
        
        self.viewModel.$searchText
            .subscribe(on: DispatchQueue.global(qos: .background))
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .map({ (string) -> String? in
                if string.count < 1 {
                    self.viewModel.filteredTags = self.viewModel.tags.filter(self.treeFilter)
                    return nil
                }
                return string.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            }) // prevents sending numerous requests and sends nil if the count of the characters is less than 1.
            .compactMap{ $0 } // removes the nil values so the search string does not get passed down to the publisher chain
            .sink(receiveCompletion: { _ in
                print("searchText receiveCompletion")
            }, receiveValue: { searchText in
                print("searchText receiveValue \(searchText)")
                self.viewModel.filteredTags = self.viewModel.tags.filter { $0.lowercased().contains(searchText) }
            })
            .store(in: &cancellables)
    }
    
    func onDisappear() {
        self.cancellables.removeAll()
    }
    
    func onSave(tags: [String]) {
        self.viewModel.hasFinished = true
    }
    
    func onTap(tag: String) {
        if tag.hasSuffix("/") {
            print("selectedPath = \(tag)")
            self.viewModel.selectedPath = tag
            self.viewModel.filteredTags = self.viewModel.tags.filter(self.treeFilter)
        } else if !self.viewModel.selectedTags.contains(tag) {
            self.viewModel.selectedTags.insert(tag, at: 0)
        }
    }
    
    func onDismiss(tag: String) {
        if let index = self.viewModel.selectedTags.firstIndex(of: tag) {
            self.viewModel.selectedTags.remove(at: index)
        }
    }
    
    func onBack() {
        if let path = self.viewModel.selectedPath {
            var subStrings = path.components(separatedBy: "/")
            if subStrings.count <= 2 {
                self.viewModel.selectedPath = nil
            } else {
                subStrings.removeLast()
                subStrings.removeLast()
                if subStrings.count == 1 {
                    self.viewModel.selectedPath = subStrings.first! + "/"
                } else {
                    let total: String = subStrings.reduce("") { $0 + $1 + "/"}
                    self.viewModel.selectedPath = total
                }
            }
            self.viewModel.filteredTags = self.viewModel.tags.filter(self.treeFilter)
        }
    }
    
    func onCancelSearch() {
        self.viewModel.filteredTags = self.viewModel.tags.filter(self.treeFilter)
    }
}

extension TDTagSearchPresenter: TDTagSearchPresenterInteractorInterface {
    
}
