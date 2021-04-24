//
//  LocalSharedTestHelpers.swift
//  SeLogeriOSTests
//
//  Created by Romain Brunie on 24/04/2021.
//

import XCTest
import SeLoger

extension XCTestCase  {
    func anyInt() -> Int {
        Int.random(in: 0..<100)
    }
    
    func uniqueItem() -> PropertyListing {
        PropertyListing(bedrooms: 0,
                        city: "any city",
                        id: anyInt(),
                        area: 2.0,
                        url: nil,
                        price: 12,
                        professional: "any professional",
                        propertyType: "any propertyType",
                        rooms: 4)
    }
}
