//
//  RemotePropertyListing.swift
//  SeLoger
//
//  Created by Romain Brunie on 22/04/2021.
//

import Foundation

public struct RemotePropertyListing: Decodable {
    public let bedrooms: Int?
    public let city: String
    public let id: Int
    public let area: Float
    public let url: URL?
    public let price: Float
    public let professional: String
    public let propertyType: String
    public let rooms: Int
}
