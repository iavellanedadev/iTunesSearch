//
//  MediaTableViewCell.swift
//  iTunesSearch
//
//  Created by Consultant on 5/6/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var mainNameLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    static let identifier = "MediaTableViewCell"
    
    var url: URL?
    
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
        
    }
    
    func configureCellWith(name: String, genre: String, link: String, artUrl: String) {
//        print(name)
        mainNameLabel?.text = name
        genreLabel?.text = genre
        mainImageView.loadImage(at: artUrl)
        url = URL(string: link)
        
    }
    
}
