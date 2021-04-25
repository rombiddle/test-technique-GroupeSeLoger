//
//  RemotePropertyListingDetailLoader.swift
//  SeLoger
//
//  Created by Romain Brunie on 25/04/2021.
//

import Foundation

public class RemotePropertyListingDetailLoader: PropertyListingDetailLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = PropertyListingDetailLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(PropertyListingDetailMapper.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
