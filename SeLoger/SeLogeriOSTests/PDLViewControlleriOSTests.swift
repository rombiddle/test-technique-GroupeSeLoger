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
        
        sut.simulateUserInitiatedPropertyListingsReload()
        loader.completePropertyListingsLoadingWithError(at: 1)
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
    
    func test_loadPropertyListingsCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let property0 = uniqueItem()
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completePropertyListingsLoading(with: [property0], at: 0)
        assertThat(sut, isRendering: [property0])

        sut.simulateUserInitiatedPropertyListingsReload()
        loader.completePropertyListingsLoadingWithError(at: 1)
        assertThat(sut, isRendering: [property0])
    }
    
    func test_propertyImageView_loadsImageURLWhenVisible() {
        let property0 = uniqueItem(url: URL(string: "http://url-0.com")!)
        let property1 = uniqueItem(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completePropertyListingsLoading(with: [property0, property1])

        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")

        sut.simulatePropertyListingImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [property0.url], "Expected first image URL request once first view becomes visible")

        sut.simulatePropertyListingImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [property0.url, property1.url], "Expected second image URL request once second view also becomes visible")
    }
    
    func test_propertyImageView_rendersImageLoadedFromURL() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        let property0 = uniqueItem(url: URL(string: "http://url-0.com")!)
        let property1 = uniqueItem(url: URL(string: "http://url-1.com")!)
        loader.completePropertyListingsLoading(with: [property0, property1])

        let view0 = sut.simulatePropertyListingImageViewVisible(at: 0)
        let view1 = sut.simulatePropertyListingImageViewVisible(at: 1)
        XCTAssertEqual(view0?.renderedImage, .none, "Expected no image for first view while loading first image")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image for second view while loading second image")

        let imageData0 = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected image for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image state change for second view once first image loading completes successfully")

        let imageData1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected no image state change for first view once second image loading completes successfully")
        XCTAssertEqual(view1?.renderedImage, imageData1, "Expected image for second view once second image loading completes successfully")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PDLViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PropertyListingsUIComposer.propertyListingsComposedWith(propertyListingsLoader: loader, imageLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
         
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
    
    var renderedImage: Data? {
        return propertyImage.image?.pngData()
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
    
    @discardableResult
    func simulatePropertyListingImageViewVisible(at index: Int) -> PropertyListingCell? {
        return propertyListingView(at: index) as? PropertyListingCell
    }
}

private extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
