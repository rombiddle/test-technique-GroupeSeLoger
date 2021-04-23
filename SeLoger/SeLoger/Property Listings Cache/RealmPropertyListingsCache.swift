//
//  RealmPropertyListingsCache.swift
//  SeLoger
//
//  Created by Romain Brunie on 23/04/2021.
//

import Foundation
import RealmSwift

public class RealmPropertyListingsCache: Object {
    @objc dynamic var id = 0
    var listings = List<RealmPropertyListings>()
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(listings: [RealmPropertyListings]) {
        self.init()
        self.listings.append(objectsIn: listings)
    }
    
    func realmPropertyListingstoLocals() throws -> [LocalPropertyListing] {
        try self.listings.map { try $0.toLocal() }
    }
}
