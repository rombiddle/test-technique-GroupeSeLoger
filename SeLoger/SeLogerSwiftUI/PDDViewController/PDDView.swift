//
//  PDDView.swift
//  SeLogerSwiftUI
//
//  Created by Romain Brunie on 24/02/2022.
//

import SwiftUI
import SeLoger

public struct PDDView: View {
    @ObservedObject var viewModel: PDDViewModel
    
    public init(viewModel: PDDViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            AsyncImageView(url: viewModel.property?.url)
                .aspectRatio(1.78, contentMode: .fit)
            if let property = viewModel.property {
                VStack {
                    Text(property.propertyType)
                        .font(.footnote)
                    Text(String(format: "X_€".local(), String(property.price)))
                        .font(.headline)
                    if let rooms = property.rooms {
                        Text(String(format: "X_ROOMS".local(), String(rooms)))
                            .font(.system(size: 17))
                    }
                    if let bedrooms = property.bedrooms {
                        Text(String(format: "X_BEDROOMS".local(), String(bedrooms)))
                            .font(.system(size: 17))
                    }
                    Text(String(format: "X_M2".local(), String(property.area)))
                        .font(.system(size: 17))
                    Text(property.city)
                        .font(.system(size: 17))
                }
            }
            Spacer()
        }
    }
}

struct PDDView_Previews: PreviewProvider {
    static var previews: some View {
        PDDView(viewModel: PDDViewModel(provider: Provider()))
    }
    
    class Provider: PropertyListingDetailLoader {
        typealias Result = PropertyListingDetailLoader.Result

        func load(completion: @escaping (Result) -> Void) {
            completion(.success(PropertyListing.init(bedrooms: 0, city: "Villiers", id: 1, area: 0, url: nil, price: 150, professional: "", propertyType: "Maison", rooms: nil)))
        }
    }
}
