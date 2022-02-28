//
//  PDLListView.swift
//  SeLogerSwiftUI
//
//  Created by Romain Brunie on 24/02/2022.
//

import SwiftUI
import SeLoger

struct PDLListView: View {
    private var properties: [PropertyListingPresentation]
    private var selection: ((Int) -> PDDView)?
    private var reload: (() -> Void)?
    
    init(properties: [PropertyListingPresentation], selection: ((Int) -> PDDView)?, reload: (() -> Void)?) {
        self.properties = properties
        self.selection = selection
        self.reload = reload
    }
    
    var body: some View {
        List(properties) { property in
            NavigationLink {
                selection?(property.id)
            } label: {
                PropertyListingCell(
                    propertyImage: AsyncImageView(url: property.imageURL),
                    propertyTypeLabel: property.type,
                    priceLabel: property.price,
                    cityLabel: property.city
                )
            }
        }.refreshable {
            reload?()
        }
    }
}

struct PDLListView_Previews: PreviewProvider {
    static var previews: some View {
        let property = PropertyListingPresentation(id: 0, imageURL: nil, type: "Maison", price: "150", city: "Plaisir")
        PDLListView(properties: [property, property], selection: nil, reload: nil)
    }
}
