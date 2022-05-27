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
}

protocol TDTagSearchPresenterInteractorInterface: AnyObject {

}

final class TDTagSearchPresenter {
    var interactor: TDTagSearchInteractorPresenterInterface!
    weak var viewModel: TDTagSearchViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    private func searchFilter(_ tag: String) -> Bool {
        if self.viewModel.searchText.isEmpty { return false }
        if tag.lowercased().contains(self.viewModel.searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) { return true }
        return false
    }
}

extension TDTagSearchPresenter: TDTagSearchPresenterViewInterface {
    func onAppear() {
        self.interactor.fetchTagList()
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { error in
                // handle error
                print("completion with \(error)")
            } receiveValue: { tags in
                self.viewModel.tags = tags
                self.viewModel.filteredTags = tags.filter(self.searchFilter)
            }
            .store(in: &cancellables)
        
        self.viewModel.$searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count < 1 {
                    self.viewModel.filteredTags = self.viewModel.tags
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
}

extension TDTagSearchPresenter: TDTagSearchPresenterInteractorInterface {
    
}
