//
//  SeLogerAppTests.swift
//  SeLogerAppTests
//
//  Created by Romain Brunie on 25/04/2021.
//

import XCTest
import SeLoger

class PropertyListingsLoaderWithFallbackComposite: PropertyListingsLoader {
     private let primary: PropertyListingsLoader

     init(primary: PropertyListingsLoader, fallback: PropertyListingsLoader) {
         self.primary = primary
     }

     func load(completion: @escaping (PropertyListingsLoader.Result) -> Void) {
         primary.load(completion: completion)
     }
 }

class PropertyListingsLoaderWithFallbackCompositeTests: XCTestCase {

    func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
        let primaryPropertyListing = uniqueItems().models
        let fallbackPropertyListing = uniqueItems().models
        let primaryLoader = LoaderStub(result: .success(primaryPropertyListing))
        let fallbackLoader = LoaderStub(result: .success(fallbackPropertyListing))
        let sut = PropertyListingsLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)

        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(receivedFeed):
                XCTAssertEqual(receivedFeed, primaryPropertyListing)

            case .failure:
                XCTFail("Expected successful load feed result, got \(result) instead")
            }

            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }

    private class LoaderStub: PropertyListingsLoader {
        private let result: PropertyListingsLoader.Result

        init(result: PropertyListingsLoader.Result) {
            self.result = result
        }

        func load(completion: @escaping (PropertyListingsLoader.Result) -> Void) {
            completion(result)
        }
    }

}
