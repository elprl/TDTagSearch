//
//  TDTagSearchApp.swift
//  TDTagSearch
//
//  Created by Paul Leo on 26/05/2022.
//

import SwiftUI

@main
struct TDTagSearchApp: App {
    @State private var showPopover: Bool = false

    var body: some Scene {
        WindowGroup {
            VStack {
                Button("Show popover") {
                    self.showPopover = true
                }.popover(
                    isPresented: self.$showPopover,
                    arrowEdge: .bottom
                ) {
                    TDTagSearchRouter().build()
                        .frame(width: 600, height: 400, alignment: .center)
                    .padding() }
            }
            
        }
    }
}
