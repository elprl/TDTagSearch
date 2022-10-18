//
//  TDTagCapsuleSUI.swift
//  TDTagSearch
//
//  Created by Paul Leo on 25/05/2022.
//  Copyright © 2022 tapdigital Ltd. All rights reserved.
//

import SwiftUI

public struct TDTagCapsuleSUI: View {
    var color: Color = .red
    var font: Font = .callout
    var originalTag: String
    var parentText: String
    var childText: String?
    var isSelected: Bool = false
    var cornerRadius: CGFloat = 12.0
    var onTap: ((String) -> ())?
    var onDismiss: ((String) -> ())?
    
    public init(color: Color = .red, font: Font = .callout,
                originalTag: String, parentText: String, childText: String? = nil,
                isSelected: Bool = false, cornerRadius: CGFloat = 12.0,
                onTap: ((String) -> ())? = nil, onDismiss: ((String) -> ())? = nil) {
        self.color = color
        self.font = font
        self.originalTag = originalTag
        self.parentText = parentText
        self.childText = childText
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
        self.onTap = onTap
        self.onDismiss = onDismiss
    }

    public var body: some View {
        Button {
            self.onTap?(self.originalTag)
        } label: {
            HStack(alignment: .center, spacing: 4) {
                Text(parentText)
                    .foregroundColor(.white)
                    .padding(.leading, cornerRadius/2)
                    .padding(.trailing, 6)
                    .padding(.bottom, 1)
                    .background(color)
                if let childText = self.childText {
                    Text(childText)
                        .padding(.leading, 2)
                        .padding(.trailing, cornerRadius/2)
                        .padding(.bottom, 1)
                }
                if isSelected {
                    Button {
                        self.onDismiss?(self.originalTag)
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 20)
                    }
                    .padding(.leading, childText == nil ? 0 : -6)
                    .padding(.trailing, 4)
                    .padding(.vertical, 2)
                }
            }
            .font(font)
            .fixedSize()
            .cornerRadius(fontPointSize)
            .foregroundColor(color)
            .overlay(RoundedRectangle(cornerRadius: fontPointSize).stroke(color, lineWidth: 1.0))
        }
    }
    
    private var fontPointSize: CGFloat {
        #if canImport(UIKit)
        return font.uiFont.pointSize
        #else
        return 12.0
        #endif
    }
}

#if DEBUG

struct TDTagCapsuleSUI_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TDTagCapsuleSUI(originalTag: "|Architecture/|patterns", parentText: "|Architecture|", childText: "|patterns|")
                .padding(2)
                .previewLayout(.sizeThatFits)
            
            TDTagCapsuleSUI(originalTag: "|Architecture/", parentText: "|Architecture|", childText: nil)
                .padding(2)
                .previewLayout(.sizeThatFits)
            
            TDTagCapsuleSUI(originalTag: "Architecture/patterns", parentText: "Architecture", childText: "patterns", isSelected: true)
                .padding(2)
                .previewLayout(.sizeThatFits)
            
            TDTagCapsuleSUI(originalTag: "Architecture", parentText: "Architecture", childText: nil, isSelected: true)
                .padding(2)
                .previewLayout(.sizeThatFits)
            
            TDTagCapsuleSUI(font: .title, originalTag: "Architecture/patterns", parentText: "Architecture", childText: "patterns")
                .padding(2)
                .previewLayout(.sizeThatFits)
            
            TDTagCapsuleSUI(font: .title, originalTag: "Architecture/patterns", parentText: "Architecture", childText: "patterns", isSelected: true)
                .padding(2)
                .previewLayout(.sizeThatFits)
            
            TDTagCapsuleSUI(font: .title, originalTag: "Architecture", parentText: "Architecture", childText: nil, isSelected: true)
                .padding(2)
                .previewLayout(.sizeThatFits)
        }
    }
}

#endif
