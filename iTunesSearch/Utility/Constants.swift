//
//  Constants.swift
//  iTunesSearch
//
//  Created by Consultant on 5/6/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import Foundation

struct Constants {
    let iTunesBaseUrl: String = "https://itunes.apple.com/"
    
    func searchUrl(query: String) -> URL? {
        return URL(string: iTunesBaseUrl + "search?term=" + query)
    }
}

