//
//  ImageFetcher.swift
//  iTunesSearch
//
//  Created by Consultant on 5/8/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import UIKit

///the actual service class that fetches the images, from the endpoint or from the cache
class ImageFetcher {
    private var runningOperations = [UUID: BlockOperation]()
    private var operationQueue = OperationQueue()
    private var imageCache = NSCache<NSString, AnyObject>()
    
    /**
     Load the image from the Cache or Endpoint!
     
     Calling this method loads the image from our `imageCache`
     Alternatively, it fetches the image from an endpoint
     
     - Parameter url: The url for the image that we are attempting to load, we use the url for the key to load, or to make an API call and fetch the data
     - Return UUID: A unique identifier for the request for the url, if there is no image in the cache
     */
    func loadImage(_ url: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let cachedImage = imageCache.object(forKey: NSString(string: url)) as? UIImage {
            completion(.success(cachedImage))
            return nil
        }
        
        let uniqueId = UUID()
        
        let imageOperation = BlockOperation {
            guard let imageUrl = URL(string: url) else { return }
            imageUrl.getImage { [weak self] image in
                guard let image = image else { return }
                self?.imageCache.setObject(image, forKey: NSString(string: url))
                completion(.success(image))
                self?.runningOperations.removeValue(forKey: uniqueId)
            }
        }
        
        operationQueue.addOperation(imageOperation)
        
        runningOperations[uniqueId] = imageOperation
        
        return uniqueId
    }
    
    /**
     Cancel the image load operation!
     
     Cancels the operation using our `uniqueId` so that we don't make unnecessary calls/operations.
     
     - Parameter uniqueId: The uniqueId that was used to store the operation in our map
     */
    func cancelLoad(_ uniqueId: UUID) {
        runningOperations[uniqueId]?.cancel()
        runningOperations.removeValue(forKey: uniqueId)
    }
    
}
