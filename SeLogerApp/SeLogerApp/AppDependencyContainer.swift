//
//  PropertyListingsUIComposer.swift
//  SeLogeriOS
//
//  Created by Romain Brunie on 24/04/2021.
//

import UIKit
import SeLoger
import SeLogeriOS
import RealmSwift

final class AppDependencyContainer {
    
    // Long-lived dependencies
    let httpClient: HTTPClient
    let store: PropertyListingsStore
    let nav: UINavigationController

    init(httpClient: HTTPClient, store: PropertyListingsStore) {
        self.httpClient = httpClient
        self.store = store
        self.nav = UINavigationController()
    }
    
    func makePDLViewController() -> UIViewController {
        let remoteURL = URL(string: "https://gsl-apps-technical-test.dignp.com/listings.json")!
        let remotePropertyListingsLoader = RemotePropertyListingsLoader(url: remoteURL, client: httpClient)
        
        let remoteImageLoader = RemotePropertyListingsImageLoader(client: httpClient)
        
        let localPropertyListingsLoader = LocalPropertyListingsLoader(store: store)
        
        let pdlViewController = PDLViewController.make()
        pdlViewController.refreshController?.propertyListingsLoader = PropertyListingsLoaderWithFallbackComposite(
            primary: PropertyListingsLoaderCacheDecorator(
                decoratee: MainQueueDispatchDecorator(decoratee: remotePropertyListingsLoader),
                cache: localPropertyListingsLoader),
            fallback: MainQueueDispatchDecorator(decoratee: localPropertyListingsLoader)
        )
        pdlViewController.refreshController?.onRefresh = { [weak pdlViewController] propertyListings in
            pdlViewController?.tableModel = propertyListings.compactMap { [weak self] propertyListing in
                guard let self = self else { return nil }
                return PropertyListingCellController(model: propertyListing,
                                                     imageLoader: MainQueueDispatchDecorator(decoratee: remoteImageLoader),
                                                     selection: self.showPropertyDetail
                )
            }
        }
        pdlViewController.title = "Annonces"
        nav.setViewControllers([pdlViewController], animated: true)
        return nav
    }
    
    private func showPropertyDetail(for propertyId: Int) {
        let pddViewController = PDDViewController.make()
        let remoteURL = URL(string: "https://gsl-apps-technical-test.dignp.com/listings/\(propertyId).json")!
        let remotePropertyListingDetailLoader = RemotePropertyListingDetailLoader(url: remoteURL, client: httpClient)
        pddViewController.loadIndicatorController?.propertyListingDetailLoader = MainQueueDispatchDecorator(decoratee: remotePropertyListingDetailLoader)
        pddViewController.loadIndicatorController?.onLoadedPropertyListing = { [weak pddViewController] propertyListing in
            pddViewController?.loadedPropertyListing(model: propertyListing)
        }
        let remotePropertyListingsImageLoader = RemotePropertyListingsImageLoader(client: httpClient)
        pddViewController.imageLoader = MainQueueDispatchDecorator(decoratee: remotePropertyListingsImageLoader)
        nav.pushViewController(pddViewController, animated: true)
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

private extension PDDViewController {
    static func make() -> PDDViewController {
        let bundle = Bundle(for: PDDViewController.self)
        let storyboard = UIStoryboard(name: "PDD", bundle: bundle)
        let PDDViewController = storyboard.instantiateInitialViewController() as! PDDViewController
        return PDDViewController
    }
}
