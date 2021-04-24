//
//  PDLViewController+TestHelpers.swift
//  SeLogeriOSTests
//
//  Created by Romain Brunie on 24/04/2021.
//

import UIKit
import SeLogeriOS

extension PDLViewController {
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
    
    func simulatePropertyListingImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: 0)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
}
