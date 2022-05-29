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
#if DEBUG
let _ = Self._printChanges()
#endif
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Tags:")
                            .font(.title3)
                        Spacer()
                        TDSearchBarSUI()
                        if self.viewModel.isSearching {
                            Button {
//                                self.presenter.onCancelSearch()
                                self.viewModel.searchText = ""
                                self.viewModel.isSearching = false
                                self.viewModel.selectedPath = nil
//                                self.viewModel.filteredTags = self.viewModel.tags.filter(self.treeFilter)
                            } label: {
                                Text("Cancel")
                            }
                        }
                    }
                    HStack {
                        TDTagViewSUI(
                            presenter: presenter,
                            viewModel.selectedTags,
                            tagFont: .callout,
                            padding: 20,
                            parentWidth: proxy.size.width - 90) { tag in
                                self.viewModel.makeSelectedContent(presenter: presenter, tag: tag, font: .callout)
                            }
                        Spacer()
                        Button {
                            self.presenter.onSave(tags: viewModel.selectedTags)
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
                    if self.viewModel.selectedPath != nil {
                        Button {
                            self.presenter.onBack()
                        } label: {
                            Text("< Back")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 2)
                        }
                    }
                    TDTagViewSUI(
                        presenter: presenter,
                        viewModel.filteredTags,
                        tagFont: .callout,
                        padding: 20,
                        parentWidth: proxy.size.width) { tag in
                            self.viewModel.makeSearchContent(presenter: presenter, tag: tag, font: .callout)
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
    
    static var previews: some View {
        TDTagSearchSUI(presenter: MockPresenter(), viewModel: TDTagSearchViewModel.mock())
    }
}

#endif
