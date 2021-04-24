//
//  SeLogeriOSTests.swift
//  SeLogeriOSTests
//
//  Created by Romain Brunie on 24/04/2021.
//

import XCTest

final class PDLViewController {
    init(loader: PDLViewControlleriOSTests.LoaderSpy) {

    }
}

class PDLViewControlleriOSTests: XCTestCase {

    func test_init_doesNotLoadPropertyListing() {
        let loader = LoaderSpy()
        _ = PDLViewController(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - Helpers
         
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }

}
