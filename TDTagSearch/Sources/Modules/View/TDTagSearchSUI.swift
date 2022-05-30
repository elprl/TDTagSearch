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
        NavigationView {
            TDTagSearchScrollViewSUI(presenter: presenter)
        }
        .navigationViewStyle(.stack)
        .environmentObject(viewModel)
        .onAppear {
            self.presenter.onAppear()
        }
        .onDisappear {
            self.presenter.onDisappear()
        }
    }
}

struct TDTagSearchScrollViewSUI: View {
    var presenter: TDTagSearchPresenterViewInterface!
    @EnvironmentObject var viewModel: TDTagSearchViewModel
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.isSearching) private var isSearching
    @Environment(\.dismissSearch) private var dismissSearch
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        //        GeometryReader { proxy in
        ScrollView {
            VStack(alignment: .leading) {
                if self.viewModel.selectedTags.count > 0 {
                    Text("Selected Tags:")
                        .lineLimit(1)
                        .font(.callout)
                        .foregroundColor(.orange)
                    
                    TDTagViewSUI(
                        presenter: presenter,
                        viewModel.selectedTags,
                        tagFont: .callout,
                        padding: 20,
                        parentWidth: 600 - 90) { tag in
                            self.viewModel.makeSelectedContent(presenter: presenter, tag: tag, font: .callout)
                        }
                    Divider()
                }
                if self.viewModel.selectedPath != nil {
                    HStack {
                        Button {
                            self.presenter.onBack()
                        } label: {
                            Text("< Back")
                                .lineLimit(1)
                                .font(.callout)
                                .foregroundColor(.orange)
                                .padding(.vertical, 2)
                        }
                        Spacer()
                        Text(self.viewModel.selectedPath ?? "")
                            .lineLimit(1)
                            .font(.callout)
                            .foregroundColor(.orange)
                            .padding(.horizontal, 12)
                            .padding(.leading, -36)
                        Spacer()
                    }
                }
                TDTagViewSUI(
                    presenter: presenter,
                    viewModel.filteredTags,
                    tagFont: .callout,
                    padding: 20,
                    parentWidth: 600) { tag in
                        self.viewModel.makeSearchContent(presenter: presenter, tag: tag, font: .callout)
                    }
                    .searchable(text: self.$viewModel.searchText, placement: .toolbar, prompt: "Tag Search")
                    .onChange(of: self.viewModel.searchText) { searchText in
                        if searchText.isEmpty && !isSearching {
                            self.presenter.onCancelSearch()
                        }
                    }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Add Tags")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    self.presenter.onSave(tags: viewModel.selectedTags)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                })
                .disabled(viewModel.selectedTags.count == 0)
            }
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                })
            }
        }
        
    }
}

#if DEBUG

struct TDTagSearchSUI_Previews: PreviewProvider {
    
    static var previews: some View {
        TDTagSearchSUI(presenter: MockPresenter(), viewModel: TDTagSearchViewModel.mock())
            .previewLayout(.sizeThatFits)
    }
}

#endif
