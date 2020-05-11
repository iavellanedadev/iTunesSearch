//
//  UIImageView+Utilities.swift
//  iTunesSearch
//
//  Created by Consultant on 5/8/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImage(at url: String) {
        UIImageLoader.loader.load(url, for: self)
    }
    
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}
