//
//  RemotePropertyListingsLoader.swift
//  SeLoger
//
//  Created by Romain Brunie on 22/04/2021.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL, completion: @escaping (Result) -> Void)
}

public class RemotePropertyListingsLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = PropertyListingsLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, _)):
                if let _ = try? JSONSerialization.jsonObject(with: data) {
                    if let root = try? JSONDecoder().decode(Root.self, from: data) {
                        completion(.success(root.items.toModels()))
                    }
                } else {
                    completion(.failure(Error.invalidData))
                }
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

private struct Root: Decodable {
    let items: [RemotePropertyListing]
    let totalCount: Int
}

private extension Array where Element == RemotePropertyListing {
    func toModels() -> [PropertyListing] {
        map {
            PropertyListing(bedrooms: $0.bedrooms,
                            city: $0.city,
                            id: $0.id,
                            area: $0.area,
                            url: $0.url,
                            price: $0.price,
                            professional: $0.professional,
                            propertyType: $0.propertyType,
                            rooms: $0.rooms)
        }
    }
}
