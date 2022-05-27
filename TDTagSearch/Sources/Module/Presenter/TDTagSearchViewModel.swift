//
//  TDTagSearchViewModel.swift
//  TDTagSearch
//
//  Created by Paul Leo on 26/05/2022.
//

import Foundation
import Combine
import SwiftUI

enum LoadingState: String {
    case initial = "Initial"
    case loading = "Loading"
    case loaded = "Loaded"
    case failed = "Failed"
}

final class TDTagSearchViewModel: ObservableObject {
    @Published var tags: [String] = []
    @Published var filteredTags: [String] = []
    @Published var selectedTag: String? = nil
    @Published var loadingState: LoadingState = .initial
    @Published var searchText: String = "" {
        didSet {
            if searchText.count > 20 && oldValue.count <= 20 {
                searchText = oldValue
            }
        }
    }
}

extension TDTagSearchViewModel {
    
    func makeContent(tag: String) -> some View {
        let color = color(from: tag)
        let (parent, child) = parse(tag: tag)
        return TDTagCapsuleSUI(color: color, parentText: parent, childText: child)
    }
    
    func parse(tag: String, tagStyle: TagStyle = .rootChild) -> (String, String?) {
        let subStrings = tag.components(separatedBy: "/")
        if tagStyle == .parentChild {
            if subStrings.count > 1 {
                return (subStrings[subStrings.count-2], subStrings.last)
            } else if subStrings.count == 1 {
                return (subStrings.first!, nil)
            }
        } else if tagStyle == .rootChild {
            if subStrings.count > 1 {
                return (subStrings.first!, subStrings.last)
            } else if subStrings.count == 1 {
                return (subStrings.first!, nil)
            }
        } else {
            if subStrings.count > 0 {
                return (subStrings.last!, nil)
            }
        }
        return ("", nil)
    }
    
    func color(from tag: String) -> Color {
        switch tag.prefix(1).lowercased() {
        case "a"..."e": return .red
        case "f"..."k": return .green
        case "l"..."p": return .blue
        case "q"..."u": return .orange
        default: return .gray
        }
    }
}
