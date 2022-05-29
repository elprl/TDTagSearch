//
//  String+Utils.swift
//  TDTagSearch
//
//  Created by Paul Leo on 28/05/2022.
//

import Foundation

extension String {
    
    func parse(with style: TagStyle = .parentChild) -> (String, String?) {
        let subStrings = self.components(separatedBy: "/")
        if style == .parentChild {
            if self.hasSuffix("/") {
                if subStrings.count > 2 {
                    return (subStrings[subStrings.count-3], subStrings[subStrings.count-2])
                } else if subStrings.count <= 2 {
                    return (subStrings.first!, nil)
                }
            } else {
                if subStrings.count > 1 {
                    return (subStrings[subStrings.count-2], subStrings.last)
                } else if subStrings.count == 1 {
                    return (subStrings.first!, nil)
                }
            }
        } else if style == .rootChild {
            if self.hasSuffix("/") {
                if subStrings.count > 2 {
                    return (subStrings.first!, subStrings[subStrings.count-2])
                } else if subStrings.count <= 2 {
                    return (subStrings.first!, nil)
                }
            } else {
                if subStrings.count > 1 {
                    return (subStrings.first!, subStrings.last)
                } else if subStrings.count == 1 {
                    return (subStrings.first!, nil)
                }
            }
        } else {
            if subStrings.count > 0 {
                return (subStrings.last!, nil)
            }
        }
        return ("", nil)
    }
}
