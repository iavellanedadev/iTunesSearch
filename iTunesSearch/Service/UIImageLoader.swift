//
//  UIImageLoader.swift
//  iTunesSearch
//
//  Created by Consultant on 5/8/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import UIKit

///Our singleton class for Loading the images onto the imageView, or cancelling the load if the user scrolls away from the image (on the cell)
final class UIImageLoader {
    static let loader = UIImageLoader()
    
    private let imageFetcher = ImageFetcher()
    private var imageIdStorage = [UIImageView: UUID]()
    
    private init() {}
    
    /**
     Load the image!
     
     Calling this method loads the image from our `ImageFetcher` service.
     
     - Parameter url: The url for the image that we are attempting to load
     */
    func load(_ url: String, for imageView: UIImageView) {
        
        let uniqueId = imageFetcher.loadImage(url) { result in
            
            defer { self.imageIdStorage.removeValue(forKey: imageView) }
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch {
                print("Error Loading Image: \(error.localizedDescription)")
            }
        }
        
        if let uniqueId = uniqueId {
            imageIdStorage[imageView] = uniqueId
        }
    }
    
    /**
     Cancel loading the image!
     
     Calling this method cancels the image from loading through our `ImageFetcher` service.
     The User scrolled away and the image is no longer needed to load, we check for the `uniqueId` uuid identifier
     using the imageview, then cancel the load.
     
     - Parameter imageView: The imageview that we are cancelling the load for
     */
    func cancel(for imageView: UIImageView) {
        if let uniqueId = imageIdStorage[imageView] {
            imageFetcher.cancelLoad(uniqueId)
            imageIdStorage.removeValue(forKey: imageView)
        }
    }
}

