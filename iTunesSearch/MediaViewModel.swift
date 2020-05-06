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
        didSet{
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
