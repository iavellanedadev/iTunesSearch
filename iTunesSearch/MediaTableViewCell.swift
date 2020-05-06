//
//  MediaTableViewCell.swift
//  iTunesSearch
//
//  Created by Consultant on 5/6/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var artworkLabel: UIImageView!
    
    static let identifier = "MediaTableViewCell"
    
    func configureCellWith(name: String, genre: String, link: String, artUrl: String) {
        nameLabel.text = name
        genreLabel.text = genre
    }
    
}
