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
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Tags:")
                            .font(.title3)
                        Spacer()
                        TDSearchBarSUI()
                    }
                    HStack {
                        TDTagViewSUI(
                            viewModel.selectedTags,
                            tagFont: .callout,
                            padding: 20,
                            parentWidth: proxy.size.width - 90) { tag in
                                viewModel.makeSelectedContent(tag: tag, font: .callout)
                            }
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("Save")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 2)
                                .foregroundColor(.white)
                                .frame(width: 80)
                                .background(Capsule().fill(viewModel.selectedTags.count == 0 ? .gray.opacity(0.5) : .green))
                        }
                        .disabled(viewModel.selectedTags.count == 0)
                        .padding(.horizontal)
                    }
                    Divider()
                    TDTagViewSUI(
                        viewModel.filteredTags,
                        tagFont: .callout,
                        padding: 20,
                        parentWidth: proxy.size.width) { tag in
                            viewModel.makeSearchContent(tag: tag, font: .callout)
                        }
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
