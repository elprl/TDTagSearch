//
//  TDTagSearchRouter.swift
//  TDTagSearch
//
//  Created by Paul Leo on 26/05/2022.
//

import Foundation
import SwiftUI

public protocol TDTagSearchRouterProtocol {

}

final public class TDTagSearchRouter {
    
    public init() {
        
    }
    
    public func build(viewModel: TDTagSearchViewModel = TDTagSearchViewModel(), tagFilePath: String? = nil) -> some View {
        let presenter = TDTagSearchPresenter()
        let interactor = TDTagSearchInteractor()
        if let path = tagFilePath {
            interactor.filePath = path
        }
        presenter.viewModel = viewModel
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        let view = TDTagSearchSUI(presenter: presenter, viewModel: viewModel)        
        return view
    }
}

extension TDTagSearchRouter: TDTagSearchRouterProtocol {

}
