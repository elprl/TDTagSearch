//
//  TDTagViewSUI.swift
//  TDTagSearch
//
//  Created by Paul Leo on 25/05/2022.
//  Copyright © 2022 tapdigital Ltd. All rights reserved.
//

import SwiftUI

public enum TagStyle {
    case parentChild
    case rootChild
    case childOnly
}

public struct TDTagViewSUI<Content>: View where Content: View {
    private let tags: [String]
    private var tagFont: Font
    private let padding: CGFloat
    private let parentWidth: CGFloat
    private let content: (String) -> Content
    private var elementsCountByRow: [Int] = []
    private let tagStyle: TagStyle
    
    public init(_ tags: [String],
                tagFont: Font,
                padding: CGFloat,
                parentWidth: CGFloat,
                tagStyle: TagStyle = .parentChild,
                content: @escaping (String) -> Content) {
        self.tags = tags
        self.tagFont = tagFont
        self.padding = padding
        self.parentWidth = parentWidth
        self.content = content
        self.tagStyle = tagStyle
        self.elementsCountByRow = self.getElementsCountByRow(self.parentWidth)
    }
    
    private func getElementsCountByRow(_ rowSize: CGFloat) -> [Int] {
        let tagWidths = self.tags.map { tag -> CGFloat in
            let text = tag.parse(with: self.tagStyle)
            return text.0.widthOfString(usingFont: self.tagFont) + (text.1?.widthOfString(usingFont: self.tagFont) ?? 0) + (self.padding/2)
        }
        
        var currentRowTotalWidth: CGFloat = 0.0
        var currentRowElementsCount: Int = 0
        var result: [Int] = []
        
        for tagWidth in tagWidths {
            let fixedTagWidth = tagWidth + (2 * self.padding)
            if currentRowTotalWidth + fixedTagWidth <= rowSize {
                currentRowTotalWidth += fixedTagWidth
                currentRowElementsCount += 1
                guard result.count != 0 else { result.append(1); continue }
                result[result.count - 1] = currentRowElementsCount
            } else {
                currentRowTotalWidth = fixedTagWidth
                currentRowElementsCount = 1
                result.append(1)
            }
        }
        return result
    }
    
    private func getTag(elementsCountByRow: [Int], rowIndex: Int, elementIndex: Int) -> String {
        let sumOfPreviousRows = elementsCountByRow.enumerated().reduce(0) { total, next in
            if next.offset < rowIndex {
                return total + next.element
            } else {
                return total
            }
        }
        let orderedTagsIndex = sumOfPreviousRows + elementIndex
        guard self.tags.count > orderedTagsIndex else { return "" }
        return self.tags[orderedTagsIndex]
    }
    
    public var body : some View {
        LazyVStack(alignment: .leading, spacing: 0) {
            ForEach(0 ..< self.elementsCountByRow.count, id: \.self) { rowIndex in
                HStack {
                    ForEach(0 ..< self.elementsCountByRow[rowIndex], id: \.self) { elementIndex in
                        self.content(self.getTag(elementsCountByRow: self.elementsCountByRow, rowIndex: rowIndex, elementIndex: elementIndex))
                    }
                    Spacer()
                }.padding(.vertical, 4)
            }
        }
    }
}

extension String {
    func widthOfString(usingFont font: Font) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font.uiFont]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

#if canImport(UIKit)

extension Font {
    var uiFont: UIFont {
        let style: UIFont.TextStyle
        switch self {
        case .largeTitle:  style = .largeTitle
        case .title:       style = .title1
        case .title2:      style = .title2
        case .title3:      style = .title3
        case .headline:    style = .headline
        case .subheadline: style = .subheadline
        case .callout:     style = .callout
        case .caption:     style = .caption1
        case .caption2:    style = .caption2
        case .footnote:    style = .footnote
        case .body: fallthrough
        default:           style = .body
        }
        return  UIFont.preferredFont(forTextStyle: style)
    }
}

#else

extension Font {
    var uiFont: NSFont {
        let style: NSFont.TextStyle
        switch self {
        case .largeTitle:  style = .largeTitle
        case .title:       style = .title1
        case .title2:      style = .title2
        case .title3:      style = .title3
        case .headline:    style = .headline
        case .subheadline: style = .subheadline
        case .callout:     style = .callout
        case .caption:     style = .caption1
        case .caption2:    style = .caption2
        case .footnote:    style = .footnote
        case .body: fallthrough
        default:           style = .body
        }
        return  NSFont.preferredFont(forTextStyle: style)
    }
}

#endif

#if DEBUG

struct TDTagViewSUI_Previews: PreviewProvider {
    static let vm = TDTagSearchViewModel.mock()
    
    static var previews: some View {
        VStack {
            GeometryReader { proxy in
                TDTagViewSUI(
                    vm.tags,
                    tagFont: .caption,
                    padding: 20,
                    parentWidth: proxy.size.width) { tag in
                        TDTagCapsuleSUI(originalTag: tag, parentText: tag)
                    }
            }
        }
        .padding(.all, 16)
        .environmentObject(vm)
        .previewLayout(.fixed(width: 400, height: 100))
    }
}

#endif
