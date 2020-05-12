//
//  MediaViewModel.swift
//  iTunesSearch
//
//  Created by Consultant on 5/6/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import Foundation

protocol MediaUpdateDelegate : AnyObject {
    func updateView()
}

class MediaViewModel {
    weak var delegate: MediaUpdateDelegate?
    
    private let service: DataFetcher
    var media = [Media]() {
        didSet {
            orderedMedia = orderMedia(media)
        }
    }
    
    var orderedMedia = [String:[Media]]() {
        didSet {
            delegate?.updateView()
        }
    }
    
    init(service: DataFetcher = AppleiTunesService()) {
        self.service = service
    }
}

extension MediaViewModel {
    func fetchMedia(with query: String) {
        service.getData(with: query) { [weak self] results in
            switch results {
            case .success(let mediaResp):
                self?.media = mediaResp
                print("Media Count: \(mediaResp.count)")
            case .failure(let error):
                print("Error Fetching Media: \(error.errorDescription ?? error.localizedDescription)")
            }
        }
    }
}

extension MediaViewModel {
    private func orderMedia(_ media: [Media]) -> [String: [Media]]{
        var mediaDictionary = Dictionary(grouping: media, by: { $0.kind!.uppercased()})
        
        for (key, value) in mediaDictionary {
            mediaDictionary[key] = value.sorted(by: { (mediaOne, mediaTwo) -> Bool in
                mediaOne.kind! < mediaTwo.kind!
            })
        }
        
        return mediaDictionary
    }
}

extension MediaViewModel {
    private func getMediaSection(from section: Int) -> [Media] {
        let keys = orderedMedia.keys.sorted(by: {$0 < $1})
        let key = keys[section]
        guard let media = orderedMedia[key] else { return []}
        
        return media
    }
    
    public func getOrderedMedia(from section: Int, at index: Int) -> Media? {
        var media = getMediaSection(from: section)
        if let tradckId = media[index].trackId {
            media[index].isFavorite = isFavorite(id: tradckId)
        }
        return media[index]
    }
    
    public func getMediaSectionCount(at section: Int) -> Int {
        let media = getMediaSection(from: section)
        
        return media.count
    }
    
    public func getOrderedMediaKeysCount() -> Int{
        return orderedMedia.keys.count
    }
    
}

extension MediaViewModel {
    func addToFavorites(id: Int) {
        UserDefaults.standard.set(true, forKey: String(id))
    }
    
    func isFavorite(id: Int) -> Bool{
        return UserDefaults.standard.bool(forKey: String(id))
    }
    
    func removeFromFavorites(id: Int) {
        UserDefaults.standard.removeObject(forKey: String(id))
        
    }
    
    
}
