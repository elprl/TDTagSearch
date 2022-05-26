//
//  TDTagSearchApp.swift
//  TDTagSearch
//
//  Created by Paul Leo on 26/05/2022.
//

import SwiftUI

@main
struct TDTagSearchApp: App {
    var body: some Scene {
        WindowGroup {
            TDTagSearchRouter().build()
                .padding()
        }
    }
}
