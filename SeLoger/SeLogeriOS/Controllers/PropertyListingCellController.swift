//
//  PropertyListingCellController.swift
//  SeLogeriOS
//
//  Created by Romain Brunie on 24/04/2021.
//

import Foundation
import UIKit
import SeLoger

final class PropertyListingCellController {
    private let model: PropertyListing
    private var cell: PropertyListingCell?
    private let imageLoader: PropertyListingsImageLoader
    
    init(model: PropertyListing, imageLoader: PropertyListingsImageLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "PropertyListingCell") as? PropertyListingCell
        cell?.propertyTypeLabel.text = model.propertyType
        cell?.priceLabel.text = String(model.price)
        cell?.cityLabel.text = model.city
        cell?.propertyImage?.image = nil
        loadImage()
        return cell!
    }
    
    func preload() {
        loadImage()
    }
    
    private func loadImage() {
        if let url = model.url {
            imageLoader.loadImageData(from: url, completion: { [weak cell] result in
                let data = try? result.get()
                cell?.propertyImage.image = data.map(UIImage.init) ?? nil
            })
        }
    }
}
