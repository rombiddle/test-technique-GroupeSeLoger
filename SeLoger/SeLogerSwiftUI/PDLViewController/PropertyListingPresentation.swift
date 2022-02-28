//
//  PropertyListingPresentation.swift
//  SeLogerSwiftUI
//
//  Created by Romain Brunie on 25/02/2022.
//

internal struct PropertyListingPresentation: Identifiable {
    public let id: Int
    public let imageURL: URL?
    public let type: String
    public let price: String
    public let city: String
}
