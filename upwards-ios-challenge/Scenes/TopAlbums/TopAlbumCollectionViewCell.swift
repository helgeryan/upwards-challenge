//
//  TopAlbumCollectionViewCell.swift
//  upwards-ios-challenge
//
//  Created by Ryan Helgeson on 11/2/23.
//

import UIKit

class TopAlbumCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    var album: Album? {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
    }
    
    private func configure() {
        if let album = album {
            albumLabel.text = album.name
            artistLabel.text = album.artistName
            
            if let imageUrl = album.artworkUrl100,
                let url = URL(string: imageUrl) {
                DispatchQueue.global(qos: .userInteractive).async {
                    do {
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.albumImageView.image = image
                        }
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumLabel.text = ""
        artistLabel.text = ""
        albumImageView.image = nil
    }

}
