//
//  SortMenu.swift
//  upwards-ios-challenge
//
//  Created by Ryan Helgeson on 11/2/23.
//

import UIKit

protocol SortMenuDelegate {
    func selectedSortType(type: String)
}

class SortMenu: UIView {
    // MARK: - Properites
    var delegate: SortMenuDelegate?
    var sortTypes: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    
    func setupMenu(delegate: SortMenuDelegate, sortTypes: [String]) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let album = sortTypes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = album
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let album = sortTypes[indexPath.row]
        delegate?.selectedSortType(type: album)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
