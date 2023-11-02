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
    
    // MARK: - UI Elements
    @IBOutlet weak var titleSortButton: UIButton!
    @IBOutlet weak var albumSortButton: UIButton!
    
    // MARK: - Life Cycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    // MARK: - Actions
    @IBAction func doTitleSort(_ sender: Any) {
        delegate?.selectedSortType(type: "title")
    }
    
    @IBAction func doAlbumSort(_ sender: Any) {
        delegate?.selectedSortType(type: "album")
    }
}
