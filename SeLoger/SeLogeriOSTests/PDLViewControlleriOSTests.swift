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

        sut.simulateUserInitiatedPropertyListingsReload()

        XCTAssertEqual(loader.loadCallCount, 2)
    }
    
    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
    }
    
    func test_viewDidLoad_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completePropertyListingsLoading()

        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
    }
    
    func test_pullToRefresh_showsLoadingIndicator() {
        let (sut, _) = makeSUT()

        sut.simulateUserInitiatedPropertyListingsReload()

        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
    }
    
    func test_pullToRefresh_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()

        sut.simulateUserInitiatedPropertyListingsReload()
        loader.completePropertyListingsLoading()

        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
    }
    
    func test_loadPropertyListingsCompletion_rendersSuccessfullyLoadedPropertyListings() {
        let property0 = uniqueItem()
        let property1 = uniqueItem()
        let property2 = uniqueItem()
        let property3 = uniqueItem()
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completePropertyListingsLoading(with: [property0], at: 0)
        assertThat(sut, isRendering: [property0])

        sut.simulateUserInitiatedPropertyListingsReload()
        loader.completePropertyListingsLoading(with: [property0, property1, property2, property3], at: 1)
        assertThat(sut, isRendering: [property0, property1, property2, property3])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PDLViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PDLViewController.make(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
         
    class LoaderSpy: PropertyListingsLoader {
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
    }
    
    private func assertThat(_ sut: PDLViewController, isRendering propertyListings: [PropertyListing], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedPropertyListingViews() == propertyListings.count else {
            return XCTFail("Expected \(propertyListings.count) images, got \(sut.numberOfRenderedPropertyListingViews()) instead.", file: file, line: line)
        }

        propertyListings.enumerated().forEach { index, property in
            assertThat(sut, hasViewConfiguredFor: property, at: index, file: file, line: line)
        }
    }

    private func assertThat(_ sut: PDLViewController, hasViewConfiguredFor property: PropertyListing, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.propertyListingView(at: index)

        guard let cell = view as? PropertyListingCell else {
            return XCTFail("Expected \(PropertyListingCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.propertyTypeText, property.propertyType, "Expected type text to be \(String(describing: property.propertyType)) for property listing  view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.priceText, String(property.price), "Expected price text to be \(String(describing: property.price)) for property listing  view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.cityText, property.city, "Expected city text to be \(String(describing: property.city)) for property listing view at index (\(index)", file: file, line: line)
    }

    private func makePropertyListing(bedrooms: Int? = nil, city: String = "a city", area: Float = 0.0, url: URL? = nil, price: Float = 0.0, professional: String = "a professional", propertyType: String = "a propertyType", rooms: Int? = nil) -> PropertyListing {
        return PropertyListing(bedrooms: bedrooms,
                               city: city,
                               id: anyInt(),
                               area: area,
                               url: url,
                               price: price,
                               professional: professional,
                               propertyType: propertyType,
                               rooms: rooms)
    }
    
}

private extension PropertyListingCell {
    var propertyTypeText: String? {
        return propertyTypeLabel.text
    }

    var priceText: String? {
        return priceLabel.text
    }

    var cityText: String? {
        return cityLabel.text
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

private extension PDLViewController {
    static func make(loader: PropertyListingsLoader) -> PDLViewController {
        let bundle = Bundle(for: PDLViewController.self)
        let storyboard = UIStoryboard(name: "PDL", bundle: bundle)
        let PDLController = storyboard.instantiateInitialViewController() as! PDLViewController
        PDLController.loader = loader
        return PDLController
    }
    
    func simulateUserInitiatedPropertyListingsReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func numberOfRenderedPropertyListingViews() -> Int {
        return tableView.numberOfRows(inSection: 0)
    }
    
    func propertyListingView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: 0)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
}

