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
    
    func didDeselect(tag: String) {
        if let index = self.selectedTags.firstIndex(of: tag) {
            self.selectedTags.remove(at: index)
        }
    }
    
    func didSelect(tag: String) {
        if !self.selectedTags.contains(tag) {
            self.selectedTags.insert(tag, at: 0)
        }
    }
    
    func makeSelectedContent(tag: String, font: Font = .caption) -> some View {
        let color = color(from: tag)
        let (parent, child) = parse(tag: tag)
        return TDTagCapsuleSUI(color: color, font: font, originalTag: tag, parentText: parent, childText: child, isSelected: true)
    }
    
    func makeSearchContent(tag: String, font: Font = .caption) -> some View {
        let color = color(from: tag)
        let (parent, child) = parse(tag: tag)
        return TDTagCapsuleSUI(color: color, font: font, originalTag: tag, parentText: parent, childText: child)
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
