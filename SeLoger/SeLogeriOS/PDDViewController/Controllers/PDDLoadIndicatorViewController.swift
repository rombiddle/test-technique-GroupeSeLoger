//
//  PDDRefreshViewController.swift
//  SeLogeriOS
//
//  Created by Romain Brunie on 25/04/2021.
//

import UIKit
import SeLoger

public final class PDDLoadIndicatorViewController: NSObject {
    @IBOutlet weak var view: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    
    public var propertyListingDetailLoader: PropertyListingDetailLoader?
    public var onLoadedPropertyListing: ((PropertyListing) -> Void)?
    
    func load() {
        startLoader()
        errorLabel.text = nil
        propertyListingDetailLoader?.load() { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: PropertyListingDetailLoader.Result) {
        switch result {
        case let .success(propertyListing):
            onLoadedPropertyListing?(propertyListing)
            
        case .failure:
            errorLabel.text = "No Data"
        }
        stopLoader()
    }
    
    private func startLoader() {
        view?.stopAnimating()
        view?.isHidden = false
    }
    
    private func stopLoader() {
        view?.stopAnimating()
        view?.isHidden = true
    }
}
