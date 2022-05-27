//
//  TDTagCapsuleSUI.swift
//  TDTagSearch
//
//  Created by Paul Leo on 25/05/2022.
//  Copyright © 2022 tapdigital Ltd. All rights reserved.
//

import SwiftUI

struct TDTagCapsuleSUI: View {
    @EnvironmentObject var viewModel: TDTagSearchViewModel

    var color: Color = .red
    var font: Font = .callout
    var originalTag: String
    var parentText: String
    var childText: String?
    var isSelected: Bool = false
    var cornerRadius: CGFloat = 12.0
    
    var body: some View {
        HStack(spacing: 4) {
            Text(parentText)
                .foregroundColor(.white)
                .padding(.leading, cornerRadius/2)
                .padding(.trailing, 4)
                .padding(.bottom, 1)
                .background(color)
            if let childText = self.childText {
                Text(childText)
                    .padding(.trailing, cornerRadius/2)
                    .padding(.bottom, 1)
            }
            if isSelected {
                Button {
                    self.viewModel.didDeselect(tag: self.originalTag)
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
        .cornerRadius(font.uiFont.pointSize)
        .foregroundColor(color)
        .overlay(RoundedRectangle(cornerRadius: font.uiFont.pointSize).stroke(color, lineWidth: 1.0))
    }
}

#if DEBUG

struct TDTagCapsuleSUI_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TDTagCapsuleSUI(originalTag: "Architecture/patterns", parentText: "Architecture", childText: "patterns")
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
