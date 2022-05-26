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
            }
            .store(in: &cancellables)
    }
    
    func onDisappear() {
        self.cancellables.removeAll()
    }
}

extension TDTagSearchPresenter: TDTagSearchPresenterInteractorInterface {
    
}
