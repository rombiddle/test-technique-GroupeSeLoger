//
//  SharedTestHelpers.swift
//  SeLogerTests
//
//  Created by Romain Brunie on 23/04/2021.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
