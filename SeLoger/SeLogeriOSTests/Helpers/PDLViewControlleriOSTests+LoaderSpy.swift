//
//  PDLViewControlleriOSTests+LoaderSpy.swift
//  SeLogeriOSTests
//
//  Created by Romain Brunie on 24/04/2021.
//

import Foundation
import SeLoger

extension PDLViewControlleriOSTests {
    class LoaderSpy: PropertyListingsLoader, PropertyListingsImageLoader {
        private var completions = [(PropertyListingsLoader.Result) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }

        func load(completion: @escaping (PropertyListingsLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completePropertyListingsLoading(with propertyListings: [PropertyListing] = [], at index: Int = 0) {
            completions[index](.success(propertyListings))
        }
        
        func completePropertyListingsLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            completions[index](.failure(error))
        }
        
        // MARK: - PropertyListingsImageLoader
        
        private var imageRequests = [(url: URL, completion: (PropertyListingsImageLoader.Result) -> Void)]()
        
        var loadedImageURLs: [URL] {
            return imageRequests.map { $0.url }
        }

        func loadImageData(from url: URL, completion: @escaping (PropertyListingsImageLoader.Result) -> Void) {
            imageRequests.append((url, completion))
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            imageRequests[index].completion(.success(imageData))
        }
    }
}
