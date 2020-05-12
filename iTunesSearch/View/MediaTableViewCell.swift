//
//  MediaTableViewCell.swift
//  iTunesSearch
//
//  Created by Consultant on 5/6/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import UIKit

protocol FavoriteService: AnyObject {
    func addToFavorites(id: Int)
    
    func removeFromFavorites(id: Int)
}

class MediaTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainNameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    static let identifier = "MediaTableViewCell"
    
    var url: URL?
    var id: Int?
    var isFavorite: Bool!
    weak var favoriteDelegate: FavoriteService?
    
    override func prepareForReuse() {
        super .prepareForReuse()
        mainImageView.cancelImageLoad()

    }
    
    @IBAction func visitPageButtonTouch(_ sender: UIButton) {
        if let url = url {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @IBAction func favoriteButtonTouch(_ sender: UIButton) {
        guard let trackId = id else { return }
        if !isFavorite {
            favoriteDelegate?.addToFavorites(id: trackId)
        }
        else {
            favoriteDelegate?.removeFromFavorites(id: trackId)
        }
        adjustFavoriteButton()
    }
    
    func adjustFavoriteButton() {
        if !isFavorite {
            favoriteButton.tintColor = .yellow
            favoriteButton.setImage(UIImage(systemName: "star.fill"
            ), for: .normal)
        }
        else {
            favoriteButton.tintColor = .systemBlue
            favoriteButton.setImage(UIImage(systemName: "star"
            ), for: .normal)
        }
    }
    
    func configureCellWith(name: String, genre: String, link: String, artUrl: String, trackId: Int, favorite: Bool) {
//        print(name)
        mainNameLabel?.text = name
        genreLabel?.text = genre
        mainImageView.loadImage(at: artUrl)
        url = URL(string: link)
        id = trackId
        isFavorite = favorite
    }
    
}
