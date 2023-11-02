//
//  SortMenu.swift
//  upwards-ios-challenge
//
//  Created by Ryan Helgeson on 11/2/23.
//

import UIKit

protocol SortMenuDelegate {
    func selectedSortType(type: SortType)
}

class SortMenu: UIView {
    // MARK: - Properites
    var delegate: SortMenuDelegate?
    var sortTypes: [SortType] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    
    func setupMenu(delegate: SortMenuDelegate, sortTypes: [SortType]) {
        tableView.register(SortMenuTableViewCell.self, forCellReuseIdentifier: SortMenuTableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        self.sortTypes = sortTypes
        self.delegate = delegate
    }
    
}

// MARK: - UITableViewDataSource
extension SortMenu: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sort = sortTypes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SortMenuTableViewCell.description(), for: indexPath) as! SortMenuTableViewCell
        cell.sortLabel.text = sort.title
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sort = sortTypes[indexPath.row]
        delegate?.selectedSortType(type: sort)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
