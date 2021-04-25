//
//  PDLRefreshViewController.swift
//  SeLogeriOS
//
//  Created by Romain Brunie on 24/04/2021.
//

import UIKit
import SeLoger

public final class PDLRefreshViewController: NSObject {
    @IBOutlet var view: UIRefreshControl?
    
    public var propertyListingsLoader: PropertyListingsLoader?
    public var onRefresh: (([PropertyListing]) -> Void)?
    
    @IBAction func refresh() {
        view?.beginRefreshing()
        propertyListingsLoader?.load { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: PropertyListingsLoader.Result) {
        switch result {
        case let .success(propertyListings):
            onRefresh?(propertyListings)
        case .failure:
            break
        }
        view?.endRefreshing()
    }
}