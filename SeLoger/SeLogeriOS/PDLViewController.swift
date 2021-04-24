//
//  PDLViewController.swift
//  SeLogeriOS
//
//  Created by Romain Brunie on 24/04/2021.
//

import UIKit
import SeLoger

public final class PDLViewController: UIViewController {
    private var loader: PropertyListingsLoader?

    public convenience init(loader: PropertyListingsLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        loader?.load { _ in }
    }
}
