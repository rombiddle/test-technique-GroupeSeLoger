//
//  PropertyListingPresentationMapper.swift
//  SeLogerSwiftUI
//
//  Created by Romain Brunie on 25/02/2022.
//

import SeLoger

internal class PropertyListingPresentationMapper {
    internal static func map(_ properties: [PropertyListing]) -> [PropertyListingPresentation] {
        return properties.map { property in
            PropertyListingPresentation(
                id: property.id,
                imageURL: property.url,
                type: property.propertyType,
                price: String(format: "X_€".local(), String(property.price)),
                city: property.city
            )
        }
    }
}
