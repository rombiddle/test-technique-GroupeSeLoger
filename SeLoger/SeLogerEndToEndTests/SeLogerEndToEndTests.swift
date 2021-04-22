//
//  SeLogerEndToEndTests.swift
//  SeLogerEndToEndTests
//
//  Created by Romain Brunie on 22/04/2021.
//

import XCTest
import SeLoger

class SeLogerEndToEndTests: XCTestCase {

    func test_endToEndTestServerGetPropertyListingsResult_matchesFixedTestAccountData() {
        let testServerURL = URL(string: "https://gsl-apps-technical-test.dignp.com/listings.json")!
        let client = URLSessionHTTPClient()
        let loader = RemotePropertyListingsLoader(url: testServerURL, client: client)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: RemotePropertyListingsLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3.0)
        
        switch receivedResult {
        case let .success(listings)?:
            XCTAssertEqual(listings.count, 4)
            XCTAssertEqual(listings, expectedRequirements())
            
        case let .failure(error)?:
            XCTFail("expected successful requirements result, got \(error) instead")
            
        default:
            XCTFail("expected successful requirements result, got no instead")
        }
    }
    
    // MARK: - Helpers

    private func expectedRequirements() -> [PropertyListing] {
        let property1 = PropertyListing(bedrooms: 4, city: "Villers-sur-Mer", id: 1, area: 250.0, url: URL(string: "https://v.seloger.com/s/crop/590x330/visuels/1/7/t/3/17t3fitclms3bzwv8qshbyzh9dw32e9l0p0udr80k.jpg")!, price: 1500000.0, professional: "GSL EXPLORE", propertyType: "Maison - Villa", rooms: 8)
        
        let property2 = PropertyListing(bedrooms: 7, city: "Deauville", id: 2, area: 600.0, url: URL(string: "https://v.seloger.com/s/crop/590x330/visuels/2/a/l/s/2als8bgr8sd2vezcpsj988mse4olspi5rfzpadqok.jpg"), price: 3500000.0, professional: "GSL STICKINESS", propertyType: "Maison - Villa", rooms: 11)
        
        let property3 = PropertyListing(bedrooms: nil, city: "Bordeaux", id: 3, area: 550.0, url: nil, price: 3000000.0, professional: "GSL OWNERS", propertyType: "Maison - Villa", rooms: 7)
        
        let property4 = PropertyListing(bedrooms: nil, city: "Nice", id: 4, area: 250.0, url: URL(string: "https://v.seloger.com/s/crop/590x330/visuels/1/9/f/x/19fx7n4og970dhf186925d7lrxv0djttlj5k9dbv8.jpg"), price: 5000000.0, professional: "GSL CONTACTING", propertyType: "Maison - Villa", rooms: nil)
        
        return [property1, property2, property3, property4]
    }
}
