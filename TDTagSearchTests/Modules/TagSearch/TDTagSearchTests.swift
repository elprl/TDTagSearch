//
//  TDTagSearchTests.swift
//  TDTagSearchTests
//
//  Created by Paul Leo on 26/05/2022.
//  Copyright © 2022 tapdigital Ltd. All rights reserved.
//

import XCTest
import Quick
import Nimble
import SwiftUI
import ViewInspector
@testable import TDTagSearch

extension TDTagSearchSUI: Inspectable {}

class TDTagSearchTests: QuickSpec {

    override func spec() {
        describe("FEATURE - Tag Searching") {
            beforeEach {
                
            }
            
            describe("GIVEN a user needs to tag a defect as quickly as possible") {
                context("WHEN the tag view first appears") {
                    it("THEN only the root tags appear") {
                        let view = TDTagSearchSUI()
                        let inspectedName = try view.inspect().find(text: /*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                        let fontStyle = try inspectedName.attributes().font().style()
                        expect(fontStyle).to(equal(.title))
                    }
                }
            }
        }
    }

}
