//
//  SeLogeriOSTests.swift
//  SeLogeriOSTests
//
//  Created by Romain Brunie on 24/04/2021.
//

import XCTest
import SeLogeriOS
import SeLoger

class PDLViewControlleriOSTests: XCTestCase {

    func test_init_doesNotLoadPropertyListing() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsPropertyListing() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_pullToRefresh_loadsPropertyListings() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        sut.refreshControl?.simulatePullToRefresh()

        XCTAssertEqual(loader.loadCallCount, 2)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PDLViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PDLViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
         
    class LoaderSpy: PropertyListingsLoader {
        private(set) var loadCallCount: Int = 0
        
        func load(completion: @escaping (PropertyListingsLoader.Result) -> Void) {
            loadCallCount += 1
        }
    }

}

private extension UIRefreshControl {
     func simulatePullToRefresh() {
         allTargets.forEach { target in
             actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                 (target as NSObject).perform(Selector($0))
             }
         }
     }
 }
