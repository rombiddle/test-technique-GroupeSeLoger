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
    
    func test_propertyImageView_preloadsImageURLWhenNearVisible() {
        let property0 = uniqueItem(url: URL(string: "http://url-0.com")!)
        let property1 = uniqueItem(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completePropertyListingsLoading(with: [property0, property1])
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until image is near visible")

        sut.simulatePropertyListingImageViewNearVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [property0.url], "Expected first image URL request once first image is near visible")

        sut.simulatePropertyListingImageViewNearVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [property0.url, property1.url], "Expected second image URL request once second image is near visible")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PDLViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PDLViewController.make()
        sut.refreshController?.propertyListingsLoader = loader
        sut.refreshController?.onRefresh = { [weak sut] propertyListings in
            sut?.tableModel = propertyListings.compactMap { [weak self] propertyListing in
                guard self != nil else { return nil }
                return PropertyListingCellController(model: propertyListing,
                                                     imageLoader: loader,
                                                     selection: { _ in })
            }
        }
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
}

private extension PDLViewController {
    static func make() -> PDLViewController {
        let bundle = Bundle(for: PDLViewController.self)
        let storyboard = UIStoryboard(name: "PDL", bundle: bundle)
        let PDLController = storyboard.instantiateInitialViewController() as! PDLViewController
        return PDLController
    }
}
