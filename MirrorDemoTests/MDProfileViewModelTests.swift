//
//  MDProfileViewModelTests.swift
//  MirrorDemoTests
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 7/5/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

import XCTest
@testable import MirrorDemo

var profileVMUnderTest:MDProfileViewModel!

class MDProfileViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        profileVMUnderTest = MDProfileViewModel()
    }
    
    override func tearDown() {
       profileVMUnderTest = nil
        super.tearDown()
    }
    
    func testFeetInchesFromCentimeter() {
        
        let height = profileVMUnderTest.feetInchesFromCentimeters(150)
        XCTAssertNotEqual(height.feet, 0, "Feet from centimeter is wrong")
    }
}
