//
//  UIRefreshControl+TestHelpers.swift
//  SeLogeriOSTests
//
//  Created by Romain Brunie on 24/04/2021.
//

import UIKit

extension UIRefreshControl {
     func simulatePullToRefresh() {
         allTargets.forEach { target in
             actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                 (target as NSObject).perform(Selector($0))
             }
         }
     }
 }
