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
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text("Tags:")
                    .font(.title3)
                TDTagViewSUI(
                    viewModel.selectedTags,
                    tagFont: .callout,
                    padding: 20,
                    parentWidth: geometry.size.width) { tag in
                        viewModel.makeSelectedContent(tag: tag, font: .callout)
                    }
                TDSearchBarSUI()
                TDTagViewSUI(
                    viewModel.filteredTags,
                    tagFont: .callout,
                    padding: 20,
                    parentWidth: geometry.size.width) { tag in
                        viewModel.makeSearchContent(tag: tag, font: .callout)
                    }
            }
        }
        .padding()
        .environmentObject(viewModel)
        .onAppear {
            self.presenter.onAppear()
        }
        .onDisappear {
            self.presenter.onDisappear()
        }
    }
}

#if DEBUG

struct TDTagSearchSUI_Previews: PreviewProvider {
    class MockPresenter: TDTagSearchPresenterViewInterface {
        func onAppear() { }
        func onDisappear() { }
    }
    
    static var previews: some View {
        TDTagSearchSUI(presenter: MockPresenter(), viewModel: TDTagSearchViewModel.mock())
    }
}

#endif
