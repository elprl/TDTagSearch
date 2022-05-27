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
                        .padding(.trailing, cornerRadius/2)
                        .padding(.vertical, 2)
                }
            }
        }
        .font(font)
        .fixedSize()
        .cornerRadius(cornerRadius)
        .foregroundColor(color)
        .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: 1.0))
    }
}

struct TDTagCapsuleSUI_Previews: PreviewProvider {
    static var previews: some View {
        TDTagCapsuleSUI(originalTag: "Architecture/patterns", parentText: "Architecture", childText: "patterns")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
