//
//  UpwardsSortTests.swift
//  upwards-ios-challengeTests
//
//  Created by Ryan Helgeson on 11/4/23.
//

import XCTest
import Foundation

final class UpwardsSortTests: XCTestCase {
    
    // MARK: - Setup
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    // MARK: - Teardown
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Tests
    func testSortTitleName() throws {
        let albums = [
            Album(id: "1", name: "Red", artworkUrl100: nil, artistName: "Taylor Swift", releaseDate: Date()),
            Album(id: "2", name: "To Be Eaten Alive", artworkUrl100: nil, artistName: "Mariah the Scientist", releaseDate: Date()),
            Album(id: "3", name: "Decided 2", artworkUrl100: nil, artistName: "Young Boy Never Broke Again", releaseDate: Date()),
            Album(id: "4", name: "Tee\'s Coney Island", artworkUrl100: nil, artistName: "Tee Grizzly", releaseDate: Date()),
            Album(id: "5", name: "Larger Than Life", artworkUrl100: nil, artistName: "Brent Faiyaz", releaseDate: Date()),
        ]
        
        let titleSortType = AlbumSortType.title
        
        let sortedAlbumsByTitle = albums.sorted(by: titleSortType.sort)
        
        let correctSortedAlbums = [
            Album(id: "3", name: "Decided 2", artworkUrl100: nil, artistName: "Young Boy Never Broke Again", releaseDate: Date()),
            Album(id: "5", name: "Larger Than Life", artworkUrl100: nil, artistName: "Brent Faiyaz", releaseDate: Date()),
            Album(id: "1", name: "Red", artworkUrl100: nil, artistName: "Taylor Swift", releaseDate: Date()),
            Album(id: "4", name: "Tee\'s Coney Island", artworkUrl100: nil, artistName: "Tee Grizzly", releaseDate: Date()),
            Album(id: "2", name: "To Be Eaten Alive", artworkUrl100: nil, artistName: "Mariah the Scientist", releaseDate: Date()),
        ]
        
        XCTAssertEqual(correctSortedAlbums, sortedAlbumsByTitle)
    }
    
    func testSortArtistName() throws {
        let albums = [
            Album(id: "1", name: "Red", artworkUrl100: nil, artistName: "Taylor Swift", releaseDate: Date()),
            Album(id: "2", name: "To Be Eaten Alive", artworkUrl100: nil, artistName: "Mariah the Scientist", releaseDate: Date()),
            Album(id: "3", name: "Decided 2", artworkUrl100: nil, artistName: "Young Boy Never Broke Again", releaseDate: Date()),
            Album(id: "4", name: "Tee\'s Coney Island", artworkUrl100: nil, artistName: "Tee Grizzly", releaseDate: Date()),
            Album(id: "5", name: "Larger Than Life", artworkUrl100: nil, artistName: "Brent Faiyaz", releaseDate: Date()),
        ]
        
        let artistSortType = AlbumSortType.artist
        
        let sortedAlbumsByArtist = albums.sorted(by: artistSortType.sort)
        
        let correctSortedAlbums = [
            Album(id: "5", name: "Larger Than Life", artworkUrl100: nil, artistName: "Brent Faiyaz", releaseDate: Date()),
            Album(id: "2", name: "To Be Eaten Alive", artworkUrl100: nil, artistName: "Mariah the Scientist", releaseDate: Date()),
            Album(id: "1", name: "Red", artworkUrl100: nil, artistName: "Taylor Swift", releaseDate: Date()),
            Album(id: "4", name: "Tee\'s Coney Island", artworkUrl100: nil, artistName: "Tee Grizzly", releaseDate: Date()),
            Album(id: "3", name: "Decided 2", artworkUrl100: nil, artistName: "Young Boy Never Broke Again", releaseDate: Date()),
        ]
        
        XCTAssertEqual(correctSortedAlbums, sortedAlbumsByArtist)
    }
    
    func testSortAlbumId() throws {
        let albums = [
            Album(id: "2", name: "To Be Eaten Alive", artworkUrl100: nil, artistName: "Mariah the Scientist", releaseDate: Date()),
            Album(id: "1", name: "Red", artworkUrl100: nil, artistName: "Taylor Swift", releaseDate: Date()),
            Album(id: "5", name: "Larger Than Life", artworkUrl100: nil, artistName: "Brent Faiyaz", releaseDate: Date()),
            Album(id: "3", name: "Decided 2", artworkUrl100: nil, artistName: "Young Boy Never Broke Again", releaseDate: Date()),
            Album(id: "4", name: "Tee\'s Coney Island", artworkUrl100: nil, artistName: "Tee Grizzly", releaseDate: Date()),
        ]
        
        let albumSortType = AlbumSortType.albumId
        
        let sortedAlbumsByAlbumId = albums.sorted(by: albumSortType.sort)
        
        let correctSortedAlbums = [
            Album(id: "1", name: "Red", artworkUrl100: nil, artistName: "Taylor Swift", releaseDate: Date()),
            Album(id: "2", name: "To Be Eaten Alive", artworkUrl100: nil, artistName: "Mariah the Scientist", releaseDate: Date()),
            Album(id: "3", name: "Decided 2", artworkUrl100: nil, artistName: "Young Boy Never Broke Again", releaseDate: Date()),
            Album(id: "4", name: "Tee\'s Coney Island", artworkUrl100: nil, artistName: "Tee Grizzly", releaseDate: Date()),
            Album(id: "5", name: "Larger Than Life", artworkUrl100: nil, artistName: "Brent Faiyaz", releaseDate: Date()),
        ]
        
        XCTAssertEqual(correctSortedAlbums, sortedAlbumsByAlbumId)
    }
}
