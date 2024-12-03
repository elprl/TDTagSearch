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
    @Published public var tags: [String] = []
    @Published public var filteredTags: [String] = []
    @Published public var selectedTags: [String] = []
    @Published public var selectedTag: String? = nil
    @Published public var selectedPath: String? = nil
    @Published public var loadingState: LoadingState = .initial
    @Published public var isSearching: Bool = false
    @Published public var hasFinished: Bool = false
    @Published var searchText: String = "" {
        didSet {
            if searchText.count > 20 && oldValue.count <= 20 {
                searchText = oldValue
            }
        }
    }
    
    public init(tags: [String] = []) {
        self.tags = tags
    }
}

extension TDTagSearchViewModel {
    
    func makeSelectedContent(presenter: TDTagSearchPresenterViewInterface, tag: String, font: Font = .caption, tagStyle: TagStyle = .parentChild) -> some View {
        let color = color(from: tag)
        let (parent, child) = tag.parse(with: tagStyle)
        return TDTagCapsuleSUI(color: color, font: font, originalTag: tag, parentText: parent, childText: child, isSelected: true) { tag in
            presenter.onTap(tag: tag)
        } onDismiss: { tag in
            presenter.onDismiss(tag: tag)
        }
    }
    
    func makeSearchContent(presenter: TDTagSearchPresenterViewInterface, tag: String, font: Font = .caption, tagStyle: TagStyle = .parentChild) -> some View {
        let color = color(from: tag)
        let (parent, child) = tag.parse(with: tagStyle)
        return TDTagCapsuleSUI(color: color, font: font, originalTag: tag, parentText: parent, childText: child) { tag in
            presenter.onTap(tag: tag)
        } onDismiss: { tag in
            presenter.onDismiss(tag: tag)
        }
    }
    
    func color(from tag: String) -> Color {
        switch tag.prefix(2).lowercased() {
        case "ar": return Color(hex: "1C5D5D")!
        case "co": return Color(hex: "662022")!
        case "de": return Color(hex: "B17130")!
        case "er": return Color(hex: "DE0A04")!
        case "ge": return Color(hex: "7B0542")!
        case "ma": return Color(hex: "C305FA")!
        case "pr": return .green
        case "re": return Color(hex: "66622E")!
        case "se": return Color(hex: "DA4832")!
        case "sc": return Color(hex: "DE04CC")!
        case "te": return Color(hex: "8A05FF")!
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
