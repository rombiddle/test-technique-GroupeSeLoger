//
//  PDLViewModel.swift
//  SeLogerSwiftUI
//
//  Created by Romain Brunie on 22/02/2022.
//

import Foundation
import SeLoger
import SwiftUI

public class PDLViewModel: ObservableObject {
    @Published internal var properties: [PropertyListingPresentation] = []
    public var propertyListingsLoader: PropertyListingsLoader?
    
    public init(propertyListingsLoader: PropertyListingsLoader) {
        self.propertyListingsLoader = propertyListingsLoader
        reload()
    }
    
    public func reload() {
        propertyListingsLoader?.load(completion: { result in
            switch result {
            case .success(let properties):
                self.properties = PropertyListingPresentationMapper.map(properties)
            case .failure(let error):
                print(error)
            }
        })
    }
}
