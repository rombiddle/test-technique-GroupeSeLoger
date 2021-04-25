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
    @IBOutlet weak var propertyRoomsLabel: UILabel!
    @IBOutlet weak var propertyBedroomsLabel: UILabel!
    @IBOutlet weak var propertyCityLabel: UILabel!
    @IBOutlet weak var propertyPriceLabel: UILabel!
    @IBOutlet weak var propertyAreaLabel: UILabel!
    @IBOutlet public weak var loadIndicatorController: PDDLoadIndicatorViewController?
    
    private(set) var propertyListing: PropertyListing?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loadIndicatorController?.load()
    }
    
    public func loadedPropertyListing(model: PropertyListing) {
        self.propertyListing = model
        
        if let nbOfRoom = model.rooms {
            propertyRoomsLabel.text = "\(nbOfRoom)"
        }
        propertyCityLabel.text = model.city
        if let nbOfBedrooms = model.bedrooms {
            propertyBedroomsLabel.text = "\(nbOfBedrooms)"
        }
        propertyPriceLabel.text = "\(model.price)"
        propertyAreaLabel.text = "\(model.area)"
        
        if let url = model.url {
            
        }
    }
}
