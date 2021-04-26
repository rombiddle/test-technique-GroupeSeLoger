//
//  Localized.swift
//  SeLoger
//
//  Created by Romain Brunie on 26/04/2021.
//

import Foundation

public class Localized {}
 
public extension String {
    func local() -> String {
        return localizedString(for: self)
    }
    
    func localizedString(for key: String, tableName: String = "SeLoger", bundle: Bundle = Bundle(for: Localized.self), comment: String = "") -> String {
        let defaultValue = NSLocalizedString(key, comment: comment)
        return NSLocalizedString(key, tableName: tableName, bundle: bundle,value: defaultValue, comment: comment)
    }
}
