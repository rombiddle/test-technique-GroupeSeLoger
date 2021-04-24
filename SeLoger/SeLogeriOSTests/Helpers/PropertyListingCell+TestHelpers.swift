//
//  PropertyListingCell+TestHelpers.swift
//  SeLogeriOSTests
//
//  Created by Romain Brunie on 24/04/2021.
//

import Foundation
import SeLogeriOS

extension PropertyListingCell {
    var propertyTypeText: String? {
        return propertyTypeLabel.text
    }

    var priceText: String? {
        return priceLabel.text
    }

    var cityText: String? {
        return cityLabel.text
    }
    
    var renderedImage: Data? {
        return propertyImage.image?.pngData()
    }
}
