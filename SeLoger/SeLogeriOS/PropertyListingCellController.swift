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
    
    init(model: PropertyListing) {
        self.model = model
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "PropertyListingCell") as? PropertyListingCell
        cell?.propertyTypeLabel.text = model.propertyType
        cell?.priceLabel.text = String(model.price)
        cell?.cityLabel.text = model.city
        return cell!
    }
}
