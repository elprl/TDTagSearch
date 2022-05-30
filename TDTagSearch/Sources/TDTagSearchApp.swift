//
//  TDTagSearchApp.swift
//  TDTagSearch
//
//  Created by Paul Leo on 26/05/2022.
//

import SwiftUI

@main
struct TDTagSearchApp: App {
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.purple
        
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.orange,
            .font: UIFont.preferredFont(forTextStyle: .title3)
        ]
        appearance.titleTextAttributes = attrs
        
        let largeTitleAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 28, weight: .heavy)
        ]
        appearance.largeTitleTextAttributes = largeTitleAttrs
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().backgroundColor = .purple
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .orange
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
    }

    var body: some Scene {
        WindowGroup {
            RootContentView()
        }
    }
}

struct RootContentView: View {
    @State private var showPopover: Bool = false
    let viewModel = TDTagSearchViewModel()

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        VStack {
            Button("Show popover") {
                self.showPopover = true
            }.popover(
                isPresented: self.$showPopover,
                arrowEdge: .bottom
            ) {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    TDTagSearchRouter().build(viewModel: viewModel)
                        .frame(width: 600, height: 300, alignment: .center)
                } else {
                    TDTagSearchRouter().build(viewModel: viewModel)
                }
            }
        }
    }
}
