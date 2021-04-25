//
//  PDDViewController.swift
//  SeLogeriOS
//
//  Created by Romain Brunie on 25/04/2021.
//

import UIKit
import SeLoger

public final class PDDViewController: UIViewController {
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var propertyTypeLabel: UILabel!
    @IBOutlet weak var propertyRoomsLabel: UILabel!
    @IBOutlet weak var propertyBedroomsLabel: UILabel!
    @IBOutlet weak var propertyCityLabel: UILabel!
    @IBOutlet weak var propertyPriceLabel: UILabel!
    @IBOutlet weak var propertyAreaLabel: UILabel!
    @IBOutlet public weak var loadIndicatorController: PDDLoadIndicatorViewController?
    
    private(set) var propertyListing: PropertyListing?
    
    public var imageLoader: PropertyListingImageLoader?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loadIndicatorController?.load()
    }
    
    public func loadedPropertyListing(model: PropertyListing) {
        propertyListing = model
        
        propertyTypeLabel.text = model.propertyType
        propertyRoomsLabel.isHidden = model.rooms == nil
        propertyRoomsLabel.text = model.rooms != nil ? "\(String(describing: model.rooms))" : ""
        propertyCityLabel.text = model.city
        propertyBedroomsLabel.isHidden = model.bedrooms == nil
        propertyBedroomsLabel.text = model.bedrooms != nil ? "\(String(describing: model.bedrooms))" : ""
        propertyPriceLabel.text = "\(model.price)"
        propertyAreaLabel.text = "\(model.area)"
        
        if let url = model.url {
            imageLoader?.loadImageData(from: url, completion: { [weak self] result in
                let data = try? result.get()
                self?.propertyImage.image = data.map(UIImage.init) ?? nil
            })
        }
    }
}
