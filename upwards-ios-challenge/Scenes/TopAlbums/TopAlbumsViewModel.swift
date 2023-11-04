//
//  TopAlbumsViewModel.swift
//  upwards-ios-challenge
//
//  Created by Ryan Helgeson on 11/2/23.
//

import Foundation
import Combine

final class TopAlbumViewModel {
    private let iTunesAPI: ITunesAPI
    @Published var albumsPublished: [Album]? = nil
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
    init(iTunesAPI: ITunesAPI) {
        self.iTunesAPI = iTunesAPI
    }
    
    func loadData() {
        isLoading = true
        error = nil
        iTunesAPI.getTopAlbums(limit: 10) { [weak self] res in
          
            switch res {
            case .success(let data):
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self?.albumsPublished = data.feed.results
                    self?.isLoading = false
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self?.error = err
                    self?.isLoading = false
                }
                debugPrint(err)
            }
        }
    }
    
    func sortData(type: AlbumSortType) {
        albumsPublished?.sort(by: type.sort)
    }
    
}
