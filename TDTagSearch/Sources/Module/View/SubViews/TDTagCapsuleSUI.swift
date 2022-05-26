//
//  TDTagCapsuleSUI.swift
//  TDTagSearch
//
//  Created by Paul Leo on 25/05/2022.
//  Copyright © 2022 tapdigital Ltd. All rights reserved.
//

import SwiftUI

struct TDTagCapsuleSUI: View {
    var color: Color = .red
    var font: Font = .caption
    var parentText: String
    var childText: String?
    
    var body: some View {
        HStack(spacing: 4) {
            Text(parentText)
                .foregroundColor(.white)
                .padding(.leading, 6)
                .padding(.trailing, 4)
                .padding(.bottom, 1)
                .background(color)
            if let childText = self.childText {
                Text(childText)
                    .padding(.trailing, 6)
                    .padding(.bottom, 1)
            }
        }
        .font(font)
        .fixedSize()
        .cornerRadius(12)
        .foregroundColor(color)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color, lineWidth: 1.0))
    }
}

struct TDTagCapsuleSUI_Previews: PreviewProvider {
    static var previews: some View {
        TDTagCapsuleSUI(parentText: "Architecture", childText: "patterns")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
