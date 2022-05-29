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
    @Published var selectedTags: [String] = []
    @Published var selectedTag: String? = nil
    @Published var selectedPath: String? = nil
    @Published var loadingState: LoadingState = .initial
    @Published var isSearching: Bool = false
    @Published var searchText: String = "" {
        didSet {
            if searchText.count > 20 && oldValue.count <= 20 {
                searchText = oldValue
            }
        }
    }
}

extension TDTagSearchViewModel {
    
    func makeSelectedContent(presenter: TDTagSearchPresenterViewInterface, tag: String, font: Font = .caption, tagStyle: TagStyle = .parentChild) -> some View {
        let color = color(from: tag)
        let (parent, child) = tag.parse(with: tagStyle)
        return TDTagCapsuleSUI(presenter: presenter, color: color, font: font, originalTag: tag, parentText: parent, childText: child, isSelected: true)
    }
    
    func makeSearchContent(presenter: TDTagSearchPresenterViewInterface, tag: String, font: Font = .caption, tagStyle: TagStyle = .parentChild) -> some View {
        let color = color(from: tag)
        let (parent, child) = tag.parse(with: tagStyle)
        return TDTagCapsuleSUI(presenter: presenter, color: color, font: font, originalTag: tag, parentText: parent, childText: child)
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


#if DEBUG

extension TDTagSearchViewModel {
    static func mock() -> TDTagSearchViewModel {
        let mock = TDTagSearchViewModel()
        mock.tags = ["Mock/Data", "Mock/Data1", "Mock/Data2", "Mock/Data3", "Mock/Data4", "Mock/Data5", "Mock/Data6"]
        mock.searchText = "mock"
        mock.filteredTags = mock.tags
        mock.selectedTags = ["Mock/Data"]
        return mock
    }
}

#endif
