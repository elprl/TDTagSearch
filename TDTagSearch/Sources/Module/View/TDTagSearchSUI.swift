//
//  TDTagSearchSUI.swift
//  TDTagSearch
//
//  Created by Paul Leo on 25/05/2022.
//  Copyright © 2022 tapdigital Ltd. All rights reserved.
//

import SwiftUI

struct TDTagSearchSUI: View {
    var presenter: TDTagSearchPresenterViewInterface!
    @StateObject var viewModel: TDTagSearchViewModel

    var body: some View {
        VStack {
            GeometryReader { geometry in
                TDTagViewSUI(
                    viewModel.tags,
                    tagFont: .systemFont(ofSize: 14),
                    padding: 20,
                    parentWidth: geometry.size.width) { tag in
                        TDTagCapsuleSUI(color: viewModel.color(from: tag), parentText: viewModel.parse(tag: tag).0, childText: viewModel.parse(tag: tag).1)
                    }
                    .environmentObject(viewModel)
                    .padding(.all, 16)
            }
        }
        .onAppear {
            self.presenter.onAppear()
        }
        .onDisappear {
            self.presenter.onDisappear()
        }
    }
}

struct TDTagSearchSUI_Previews: PreviewProvider {
    class MockPresenter: TDTagSearchPresenterViewInterface {
        func onAppear() {
            
        }
        
        func onDisappear() {
            
        }
    }
    
    static var previews: some View {
        TDTagSearchSUI(presenter: MockPresenter(), viewModel: TDTagSearchViewModel())
            .environmentObject(TDTagSearchViewModel())
    }
}
