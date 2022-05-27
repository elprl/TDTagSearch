//
//  TDSearchBarSUI.swift
//  TDTagSearch
//
//  Created by Paul Leo on 27/05/2022.
//

import SwiftUI

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

#if DEBUG

struct TDSearchBarSUI_Previews: PreviewProvider {
    static var previews: some View {
        TDSearchBarSUI()
            .padding()
            .environmentObject(TDTagSearchViewModel.mock())
    }
}

#endif
