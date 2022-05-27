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
                        viewModel.makeContent(tag: tag, font: .callout)
                    }
                    .frame(height: 60, alignment: .center)
                TDSearchBarSUI()
                TDTagViewSUI(
                    viewModel.filteredTags,
                    tagFont: .footnote,
                    padding: 20,
                    parentWidth: geometry.size.width) { tag in
                        viewModel.makeContent(tag: tag, font: .footnote)
                    }
                    .frame(height: 200, alignment: .center)
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

struct TDSearchBarSUI: View {
    @EnvironmentObject var viewModel: TDTagSearchViewModel

    var body: some View {
        HStack {
            TextField("Search Tags", text: $viewModel.searchText)
                .padding(.horizontal, 36)
                .frame(height: 40, alignment: .leading)
                .background(Color(#colorLiteral(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)))
                .clipped()
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                        Spacer()
                        Button {
                            self.viewModel.searchText = ""
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 8)
                        }
                    }
                )
            Spacer()
        }
    }
}

struct TDTagSearchSUI_Previews: PreviewProvider {
    class MockPresenter: TDTagSearchPresenterViewInterface {
        func onAppear() { }
        func onDisappear() { }
    }
    
    static var previews: some View {
        TDTagSearchSUI(presenter: MockPresenter(), viewModel: TDTagSearchViewModel())
            .environmentObject(TDTagSearchViewModel())
    }
}
