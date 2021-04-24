//
//  SeLogeriOSTests.swift
//  SeLogeriOSTests
//
//  Created by Romain Brunie on 24/04/2021.
//

import XCTest

final class PDLViewController: UIViewController {
    private var loader: PDLViewControlleriOSTests.LoaderSpy?

    convenience init(loader: PDLViewControlleriOSTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loader?.load()
    }
}

class PDLViewControlleriOSTests: XCTestCase {

    func test_init_doesNotLoadPropertyListing() {
        let loader = LoaderSpy()
        _ = PDLViewController(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsPropertyListing() {
        let loader = LoaderSpy()
        let sut = PDLViewController(loader: loader)

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    // MARK: - Helpers
         
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
        
        func load() {
            loadCallCount += 1
        }
    }

}
