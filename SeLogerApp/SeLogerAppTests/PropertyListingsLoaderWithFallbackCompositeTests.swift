//
//  SeLogerAppTests.swift
//  SeLogerAppTests
//
//  Created by Romain Brunie on 25/04/2021.
//

import XCTest
import SeLoger
import SeLogerApp

class PropertyListingsLoaderWithFallbackCompositeTests: XCTestCase {

    func test_load_deliversPrimaryPropertyListingsOnPrimaryLoaderSuccess() {
        let primaryPropertyListing = uniqueItems().models
        let fallbackPropertyListing = uniqueItems().models
        let sut = makeSUT(primaryResult: .success(primaryPropertyListing), fallbackResult: .success(fallbackPropertyListing))

        expect(sut, toCompleteWith: .success(primaryPropertyListing))

    }
    
    func test_load_deliversFallbackPropertyListingsOnPrimaryLoaderFailure() {
        let fallbackPropertyListing = uniqueItems().models
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackPropertyListing))

        expect(sut, toCompleteWith: .success(fallbackPropertyListing))
    }
    
    func test_load_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
        let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))

        expect(sut, toCompleteWith: .failure(anyNSError()))
    }
    
    // MARL: - Helpers
    
    private func makeSUT(primaryResult: PropertyListingsLoader.Result, fallbackResult: PropertyListingsLoader.Result, file: StaticString = #file, line: UInt = #line) -> PropertyListingsLoader {
             let primaryLoader = LoaderStub(result: primaryResult)
             let fallbackLoader = LoaderStub(result: fallbackResult)
             let sut = PropertyListingsLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
             trackForMemoryLeaks(primaryLoader, file: file, line: line)
             trackForMemoryLeaks(fallbackLoader, file: file, line: line)
             trackForMemoryLeaks(sut, file: file, line: line)
             return sut
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
    
    private func expect(_ sut: PropertyListingsLoader, toCompleteWith expectedResult: PropertyListingsLoader.Result, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedPropertyListings), .success(expectedPropertyListings)):
                XCTAssertEqual(receivedPropertyListings, expectedPropertyListings, file: file, line: line)

            case (.failure, .failure):
                break

            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

}
