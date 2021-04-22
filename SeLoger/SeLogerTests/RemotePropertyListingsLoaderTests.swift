//
//  SeLogerTests.swift
//  SeLogerTests
//
//  Created by Romain Brunie on 21/04/2021.
//

import XCTest
@testable import SeLoger

class RemotePropertyListingsLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (_, client) = makeSUT(url: url)
                
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_RequestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_RequestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(RemotePropertyListingsLoader.Error.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(RemotePropertyListingsLoader.Error.invalidData)) {
                let json = makePropertyListingsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemotePropertyListingsLoader.Error.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = makePropertyListingsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversItemsOn200HTTPRespnseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makePropertyListings(bedrooms: 4,
                                         city: "a city",
                                         id: 1,
                                         area: 125.5,
                                         url: URL(string: "https://a-given-url.com")!,
                                         price: 123.8,
                                         professional: "a professional",
                                         propertyType: "a propertyType",
                                         rooms: 5)
        
        let item2 = makePropertyListings(bedrooms: nil,
                                         city: "another city",
                                         id: 2,
                                         area: 1325.57,
                                         url: nil,
                                         price: 1234.87,
                                         professional: "another professional",
                                         propertyType: "another propertyType",
                                         rooms: 8)

        expect(sut, toCompleteWith: .success([item1.model, item2.model])) {
            let json = makePropertyListingsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemotePropertyListingsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemotePropertyListingsLoader(url: url, client: client)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        
        return (sut, client)
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    private func expect(_ sut: RemotePropertyListingsLoader, toCompleteWith expectedResult: RemotePropertyListingsLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemotePropertyListingsLoader.Error), .failure(expectedError as RemotePropertyListingsLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makePropertyListings(bedrooms: Int?, city: String, id: Int, area: Float, url: URL?, price: Float, professional: String, propertyType: String, rooms: Int) -> (model: PropertyListing, json: [String: Any]) {
        let item = PropertyListing(bedrooms: bedrooms, city: city, id: id, area: area, url: url, price: price, professional: professional, propertyType: propertyType, rooms: rooms)
        let json = jsonValue(for: item)
        
        return (item, json)
    }
    
    private func makePropertyListingsJSON(_ properties: [[String: Any]]) -> Data {
        let json = ["items": properties, "totalCount": 0] as [String : Any]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func jsonValue(for item: PropertyListing) -> [String: Any] {
        [
            "bedrooms": item.bedrooms as Any,
            "city": item.city,
            "id": item.id,
            "area": item.area,
            "url": item.url?.absoluteString as Any,
            "price": item.price,
            "professional": item.professional,
            "propertyType": item.propertyType,
            "rooms": item.rooms
        ] as [String: Any]
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
                
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success((data, response)))
        }
    }

}
