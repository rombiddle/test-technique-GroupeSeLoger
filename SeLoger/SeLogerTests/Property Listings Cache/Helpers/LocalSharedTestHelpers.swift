//
//  LocalSharedTestHelpers.swift
//  SeLogerTests
//
//  Created by Romain Brunie on 23/04/2021.
//

import Foundation
import SeLoger

func uniqueItems() -> (models: [PropertyListing], locals: [LocalPropertyListing]) {
    let items = [uniqueItem(), uniqueItem()]
    let localItems = items.map { item in
        return LocalPropertyListing(bedrooms: item.bedrooms,
                                    city: item.city,
                                    id: item.id,
                                    area: item.area,
                                    url: item.url,
                                    price: item.price,
                                    professional: item.professional,
                                    propertyType: item.propertyType,
                                    rooms: item.rooms)
    }
    return (items, localItems)
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

func anyInt() -> Int {
    Int.random(in: 0..<100)
}
