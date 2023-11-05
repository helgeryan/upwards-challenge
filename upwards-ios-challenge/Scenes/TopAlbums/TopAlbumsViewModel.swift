//
//  TopAlbumsViewModel.swift
//  upwards-ios-challenge
//
//  Created by Ryan Helgeson on 11/2/23.
//

import Foundation
import Combine

final class TopAlbumViewModel {
    private let iTunesAPI: ITunesAPIClientProtocol
    @Published var albumsPublished: [Album]? = nil
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    
    init(iTunesAPI: ITunesAPIClientProtocol) {
        self.iTunesAPI = iTunesAPI
    }
    
    func loadData() {
        isLoading = true
        error = nil
        iTunesAPI.getTopAlbums(limit: 10) { [weak self] res in
            switch res {
            case .success(let data):
                // Mocked in 2 seconds to show the spinner/lottie animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    debugPrint("Loaded")
                    self?.isLoading = false
                    self?.albumsPublished = data.feed.results
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.error = err
                }
                debugPrint(err)
            }
        }
    }
    
    func sortData(type: AlbumSortType) {
        albumsPublished?.sort(by: type.sort)
    }
}
