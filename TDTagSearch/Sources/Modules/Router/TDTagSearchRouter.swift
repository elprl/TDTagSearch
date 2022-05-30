//
//  TDTagSearchRouter.swift
//  TDTagSearch
//
//  Created by Paul Leo on 26/05/2022.
//

import Foundation
import SwiftUI

final class TDTagSearchRouter {
    
    func build(viewModel: TDTagSearchViewModel = TDTagSearchViewModel()) -> some View {
        let presenter = TDTagSearchPresenter()
        let interactor = TDTagSearchInteractor()
        interactor.presenter = presenter
        
        let view = TDTagSearchSUI(presenter: presenter, viewModel: viewModel)
        presenter.viewModel = viewModel
        presenter.interactor = interactor
        
        return view
    }
}
