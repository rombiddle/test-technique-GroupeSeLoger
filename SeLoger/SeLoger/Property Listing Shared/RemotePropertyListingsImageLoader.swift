//
//  RemotePropertyListingsImageLoader.swift
//  SeLoger
//
//  Created by Romain Brunie on 24/04/2021.
//

import Foundation

public final class RemotePropertyListingsImageLoader: PropertyListingImageLoader {
    private let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public func loadImageData(from url: URL, completion: @escaping (PropertyListingImageLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200, !data.isEmpty {
                    completion(.success(data))
                } else {
                    completion(.failure(Error.invalidData))
                }
                
            case .failure: completion(.failure(Error.connectivity))
            }
        }
    }
}
