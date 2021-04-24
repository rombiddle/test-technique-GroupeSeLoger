//
//  PDLViewController.swift
//  SeLogeriOS
//
//  Created by Romain Brunie on 24/04/2021.
//

import UIKit
import SeLoger

public final class PDLViewController: UITableViewController {
    public var loader: PropertyListingsLoader?
    var tableModel = [PropertyListingCellController]()
    
    @objc private func load() {
        loader?.load { [weak self] result in
            switch result {
            case let .success(propertyListings):
                self?.tableModel = propertyListings.map { propertyListing in
                    PropertyListingCellController(model: propertyListing)
                }
                self?.tableView.reloadData()
                
            case .failure:
                break
            }
            self?.refreshControl?.endRefreshing()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        refreshControl?.beginRefreshing()
        load()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableModel[indexPath.row].view(in: tableView)
    }
}
