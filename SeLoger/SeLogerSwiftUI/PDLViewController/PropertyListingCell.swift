//
//  PropertyListingCell.swift
//  SeLogerSwiftUI
//
//  Created by Romain Brunie on 22/02/2022.
//

import SwiftUI

struct PropertyListingCell: View {
    var propertyImage: AsyncImageView
    var propertyTypeLabel: String
    var priceLabel: String
    var cityLabel: String
    
    var body: some View {
        VStack {
            propertyImage
                .frame(height: 145)
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(propertyTypeLabel)
                        .font(.some(.footnote))
                    Text(priceLabel)
                        .font(.some(.headline))
                    Text(cityLabel)
                        .font(.system(size: 27))
                }.padding()
                Spacer()
            }
        }
        
    }
}

struct PropertyListingCell_Previews: PreviewProvider {
    static var previews: some View {
        PropertyListingCell(propertyImage: AsyncImageView(url: nil), propertyTypeLabel: "Maison", priceLabel: "15000€", cityLabel: "Plaisir")
    }
}
