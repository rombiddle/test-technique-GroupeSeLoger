//
//  PDDViewModel.swift
//  SeLogerSwiftUI
//
//  Created by Romain Brunie on 24/02/2022.
//

import SwiftUI
import SeLoger

public class PDDViewModel: ObservableObject {
    @Published var property: PropertyListing? = nil
    private var provider: PropertyListingDetailLoader
    
    public init(provider: PropertyListingDetailLoader) {
        self.provider = provider
        
        provider.load { result in
            switch result {
            case .success(let property):
                self.property = property
            case .failure(let error):
                print(error)
            }
        }
    }
}
