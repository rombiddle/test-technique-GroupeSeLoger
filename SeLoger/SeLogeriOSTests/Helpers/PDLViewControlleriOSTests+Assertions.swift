//
//  PDLViewControlleriOSTests+Assertions.swift
//  SeLogeriOSTests
//
//  Created by Romain Brunie on 24/04/2021.
//

import Foundation
import XCTest
import SeLoger
import SeLogeriOS

extension PDLViewControlleriOSTests {
    func assertThat(_ sut: PDLViewController, isRendering propertyListings: [PropertyListing], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedPropertyListingViews() == propertyListings.count else {
            return XCTFail("Expected \(propertyListings.count) images, got \(sut.numberOfRenderedPropertyListingViews()) instead.", file: file, line: line)
        }

        propertyListings.enumerated().forEach { index, property in
            assertThat(sut, hasViewConfiguredFor: property, at: index, file: file, line: line)
        }
    }

    func assertThat(_ sut: PDLViewController, hasViewConfiguredFor property: PropertyListing, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.propertyListingView(at: index)

        guard let cell = view as? PropertyListingCell else {
            return XCTFail("Expected \(PropertyListingCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.propertyTypeText, property.propertyType, "Expected type text to be \(String(describing: property.propertyType)) for property listing  view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.priceText, String(property.price), "Expected price text to be \(String(describing: property.price)) for property listing  view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.cityText, property.city, "Expected city text to be \(String(describing: property.city)) for property listing view at index (\(index)", file: file, line: line)
    }
}
