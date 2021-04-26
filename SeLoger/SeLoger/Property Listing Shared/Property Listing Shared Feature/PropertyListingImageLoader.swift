//
//  PropertyListingsImageLoader.swift
//  SeLoger
//
//  Created by Romain Brunie on 24/04/2021.
//

import Foundation

public protocol PropertyListingImageLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void)
}
