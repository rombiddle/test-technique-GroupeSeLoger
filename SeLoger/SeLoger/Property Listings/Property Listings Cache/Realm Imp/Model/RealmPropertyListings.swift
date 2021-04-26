//
//  RealmPropertyListings.swift
//  SeLoger
//
//  Created by Romain Brunie on 23/04/2021.
//

import Foundation
import RealmSwift

public class RealmPropertyListings: Object {
    var bedrooms: RealmOptional<Int> = .init(nil)
    @objc dynamic var city: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var area: Float = 0.0
    @objc dynamic var url: String? = nil
    @objc dynamic var price: Float = 0.0
    @objc dynamic var professional: String = ""
    @objc dynamic var propertyType: String = ""
    var rooms: RealmOptional<Int> = .init(nil)
    
    public convenience init(bedrooms: Int? = nil, city: String = "", id: Int = 0, area: Float = 0, url: URL? = nil, price: Float = 0, professional: String = "", propertyType: String = "", rooms: Int? = nil) {
        self.init()
        self.bedrooms = .init(bedrooms)
        self.city = city
        self.id = id
        self.area = area
        self.url = url?.absoluteString
        self.price = price
        self.professional = professional
        self.propertyType = propertyType
        self.rooms = .init(rooms)
    }
    
    public func toLocal() throws -> LocalPropertyListing {
        var url: URL? = nil
        if let stringURL = self.url {
            url = URL(string: stringURL)
        }
        
        return LocalPropertyListing(bedrooms: self.bedrooms.value,
                                    city: self.city,
                                    id: self.id,
                                    area: self.area,
                                    url: url,
                                    price: self.price,
                                    professional: self.professional,
                                    propertyType: self.propertyType,
                                    rooms: self.rooms.value)
    }
}
