//
//  PropertyListingsMapper.swift
//  SeLoger
//
//  Created by Romain Brunie on 22/04/2021.
//

import Foundation

internal final class PropertyListingsMapper {
    private struct Root: Decodable {
        let items: [Item]
        let totalCount: Int
        
        var propertyListings: [PropertyListing] {
            return items.map { $0.item }
        }
    }
    
    private struct Item: Decodable {
        let bedrooms: Int?
        let city: String
        let id: Int
        let area: Float
        let url: URL?
        let price: Float
        let professional: String
        let propertyType: String
        let rooms: Int?
        
        var item: PropertyListing {
            return PropertyListing(bedrooms: bedrooms, city: city, id: id, area: area, url: url, price: price, professional: professional, propertyType: propertyType, rooms: rooms)
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemotePropertyListingsLoader.Result {
        guard response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemotePropertyListingsLoader.Error.invalidData)
        }

        return .success(root.propertyListings)
    }
}
