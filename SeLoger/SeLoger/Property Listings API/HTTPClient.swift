//
//  HTTPClient.swift
//  SeLoger
//
//  Created by Romain Brunie on 22/04/2021.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL, completion: @escaping (Result) -> Void)
}
