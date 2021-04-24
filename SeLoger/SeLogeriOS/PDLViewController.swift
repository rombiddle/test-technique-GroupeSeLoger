//
//  PDLViewController.swift
//  SeLogeriOS
//
//  Created by Romain Brunie on 24/04/2021.
//

import UIKit
import SeLoger

public final class PDLViewController: UITableViewController {
    private var loader: PropertyListingsLoader?

    public convenience init(loader: PropertyListingsLoader) {
        self.init()
        self.loader = loader
    }
    
    @objc private func load() {
        loader?.load { _ in }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
}
