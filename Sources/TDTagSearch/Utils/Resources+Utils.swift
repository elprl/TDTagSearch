//
//  Resources+Utils.swift
//  
//
//  Created by Paul Leo on 18/10/2022.
//

import Foundation

public enum SharedResource {
    static public let defaultTagsPath = Bundle.module.path(forResource: "tags", ofType: "json")
}
