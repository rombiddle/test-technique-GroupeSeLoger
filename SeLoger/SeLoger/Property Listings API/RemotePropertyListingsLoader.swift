//
//  RemotePropertyListingsLoader.swift
//  SeLoger
//
//  Created by Romain Brunie on 22/04/2021.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL)
}

class RemotePropertyListingsLoader {
    let client: HTTPClient
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}
