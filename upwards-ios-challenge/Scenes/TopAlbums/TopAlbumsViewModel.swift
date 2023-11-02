//
//  TopAlbumsViewModel.swift
//  upwards-ios-challenge
//
//  Created by Ryan Helgeson on 11/2/23.
//

import Foundation

protocol TopAlbumViewModelDelegate {
    func dataFinishedLoading()
}

final class TopAlbumViewModel {
    var delegate: TopAlbumViewModelDelegate?
    private let iTunesAPI: ITunesAPI
    var albums = [Album]() {
        didSet {
            delegate?.dataFinishedLoading()
        }
    }
    
    init(iTunesAPI: ITunesAPI) {
        self.iTunesAPI = iTunesAPI
    }
    
    func loadData() {
        iTunesAPI.getTopAlbums(limit: 10) { [weak self] res in
            switch res {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.albums = data.feed.results
                }
            case .failure(let err):
                debugPrint(err)
            }
        }
    }
    
}
