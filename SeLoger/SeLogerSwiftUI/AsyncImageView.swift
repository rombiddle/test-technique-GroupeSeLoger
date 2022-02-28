//
//  AsyncImageView.swift
//  SeLogerSwiftUI
//
//  Created by Romain Brunie on 24/02/2022.
//

import SwiftUI

struct AsyncImageView: View {
    public var url: URL?
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                case .failure:
                    Color.gray
                case .empty:
                    ProgressView()
                @unknown default:
                    Color.gray
                }
            }
        } else {
            Color.gray
        }
    }
}

struct PDLAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "")
        AsyncImageView(url: url)
    }
}
