//
//  TDTagSearchViewModel.swift
//  TDTagSearch
//
//  Created by Paul Leo on 26/05/2022.
//

import Foundation
import Combine
import SwiftUI

public enum LoadingState: String {
    case initial = "Initial"
    case loading = "Loading"
    case loaded = "Loaded"
    case failed = "Failed"
}

final public class TDTagSearchViewModel: ObservableObject {
    @Published var tags: [String] = []
    @Published public var filteredTags: [String] = []
    @Published public var selectedTags: [String] = []
    @Published var selectedTag: String? = nil
    @Published var selectedPath: String? = nil
    @Published var loadingState: LoadingState = .initial
    @Published var isSearching: Bool = false
    @Published public var hasFinished: Bool = false
    @Published var searchText: String = "" {
        didSet {
            if searchText.count > 20 && oldValue.count <= 20 {
                searchText = oldValue
            }
        }
    }
    
    public init() {
        
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
        switch tag.prefix(2).lowercased() {
        case "ar": return Color(hex: "1C5D5D")!
        case "co": return Color(hex: "662022")!
        case "de": return Color(hex: "B17130")!
        case "do": return Color(hex: "398797")!
        case "pr": return .green
        case "re": return Color(hex: "66622E")!
        case "se": return Color(hex: "DA4832")!
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
