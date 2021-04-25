//
//  MainQueueDispatchDecorator.swift
//  SeLogerApp
//
//  Created by Romain Brunie on 25/04/2021.
//

import Foundation
import SeLoger

public final class MainQueueDispatchDecorator<T> {
    private let decoratee: T

    public init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    public func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
            
        completion()
    }
}

extension MainQueueDispatchDecorator: PropertyListingsLoader where T == PropertyListingsLoader {
    public func load(completion: @escaping (PropertyListingsLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}

extension MainQueueDispatchDecorator: PropertyListingsImageLoader where T == PropertyListingsImageLoader {
    public func loadImageData(from url: URL, completion: @escaping (PropertyListingsImageLoader.Result) -> Void) {
        decoratee.loadImageData(from: url) { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
