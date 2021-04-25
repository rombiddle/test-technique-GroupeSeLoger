//
//  PropertyListingsLoaderWithFallbackComposite.swift
//  SeLogerApp
//
//  Created by Romain Brunie on 25/04/2021.
//

import Foundation
import SeLoger

public class PropertyListingsLoaderWithFallbackComposite: PropertyListingsLoader {
    private let primary: PropertyListingsLoader
    private let fallback: PropertyListingsLoader

    public init(primary: PropertyListingsLoader, fallback: PropertyListingsLoader) {
        self.primary = primary
        self.fallback = fallback
    }

    public func load(completion: @escaping (PropertyListingsLoader.Result) -> Void) {
        primary.load { [weak self] result in
            switch result {
            case .success:
                completion(result)

            case .failure:
                self?.fallback.load(completion: completion)
            }
        }
    }
 }
