//
//  AppleiTunesService.swift
//  iTunesSearch
//
//  Created by Consultant on 5/6/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getData(with: String, completion: @escaping MediaHandler)
}

class AppleiTunesService: DataFetcher {
    func getData(with: String, completion: @escaping MediaHandler) {
        guard let url = Constants().searchUrl(query: with) else {
            completion(.failure(ErrorInfo(errorCode: .badUrl, errorDescription: "Bad URL", statusCode: 0)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            var statusCode = 500
            
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
            }
            
            if let error = error {
                let erroInfo = ErrorInfo(errorCode: .badRequest, errorDescription: "REQUEST ERROR: \(error.localizedDescription)", statusCode: statusCode)
                completion(.failure(erroInfo))
                return
            }
            
            if let data = data {
                guard let data = self.cleanJson(data: data) else { return }
                
                do {
                    guard let jsonResp = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let results = jsonResp["results"] as? [[String: Any]] else { return }

                    let cleanedResults = self.cleanData(data: results)
                    completion(.success(cleanedResults))
                } catch {
                    completion(.failure(ErrorInfo(errorCode: .parsingFailed, errorDescription: "Failed Parsing Data \(error.localizedDescription)", statusCode: statusCode)))
                }
            } else {
                completion(.failure(ErrorInfo(errorCode: .errorResponse, errorDescription: "No Data in Response", statusCode: statusCode)))
            }
            
        }
        
        task.resume()
    }
    
    func cleanJson(data: Data) -> Data? {
        guard var string = String(data: data, encoding: .utf8) else { return nil}
        
        string = string.replacingOccurrences(of: "\n\n\n", with: "")
        string = string.replacingOccurrences(of: "\n ", with: "")
        string = string.replacingOccurrences(of: "\n", with: "")
        
        guard let data = string.data(using: .utf8) else { return nil}
        return data
    }
    
    func cleanData(data: [[String: Any]]) -> [Media] {
        var media = [Media]()
        
        for element in data {

            guard let trackId = element["trackId"] as? UInt32,
                let kind = element["kind"] as? String,
                let artistName = element["artistName"] as? String,
                let collectionName = element["collectionName"] as? String,
                let trackViewUrl = element["trackViewUrl"] as? String,
                let previewUrl = element["previewUrl"] as? String,
                let primaryGenreName = element["primaryGenreName"] as? String,
                let artworkUrl = element["artworkUrl100"] as? String
                else { return media }
            
            let item = Media(trackId: Int(trackId), kind: kind, artistName: artistName, collectionName: collectionName, trackViewUrl: trackViewUrl, previewUrl: previewUrl, primaryGenreName: primaryGenreName, artworkUrl: artworkUrl)
            
            media.append(item)
            
        }
        return media
    }
}

