//
//  PropertyListing.swift
//  SeLoger
//
//  Created by Romain Brunie on 22/04/2021.
//

import Foundation

public struct PropertyListing: Equatable {
    public let bedrooms: Int?
    public let city: String
    public let id: Int
    public let area: Float
    public let url: URL?
    public let price: Float
    public let professional: String
    public let propertyType: String
    public let rooms: Int
    
    public init(bedrooms: Int?, city: String, id: Int, area: Float, url: URL?, price: Float, professional: String, propertyType: String, rooms: Int) {
        self.bedrooms = bedrooms
        self.city = city
        self.id = id
        self.area = area
        self.url = url
        self.price = price
        self.professional = professional
        self.propertyType = propertyType
        self.rooms = rooms
    }
}
