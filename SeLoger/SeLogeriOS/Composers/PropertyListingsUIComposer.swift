//
//  PropertyListingsUIComposer.swift
//  SeLogeriOS
//
//  Created by Romain Brunie on 24/04/2021.
//

import UIKit
import SeLoger

public final class PropertyListingsUIComposer {
    private init() {}

    public static func propertyListingsComposedWith(propertyListingsLoader: PropertyListingsLoader, imageLoader: PropertyListingsImageLoader) -> PDLViewController {
        let pdlViewController = PDLViewController.make()
        pdlViewController.refreshController?.propertyListingsLoader = propertyListingsLoader
        pdlViewController.refreshController?.onRefresh = { [weak pdlViewController] propertyListings in
            pdlViewController?.tableModel = propertyListings.map { propertyListing in
                PropertyListingCellController(model: propertyListing, imageLoader: imageLoader)
            }
        }
        return pdlViewController
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
