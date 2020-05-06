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
                do {
                    let response = try JSONDecoder().decode(MediaResults.self, from: data)
                    completion(.success(response.results))
                } catch {
                    completion(.failure(ErrorInfo(errorCode: .parsingFailed, errorDescription: "Failed Parsing Data \(error.localizedDescription)", statusCode: statusCode)))
                }
            } else {
                completion(.failure(ErrorInfo(errorCode: .errorResponse, errorDescription: "No Data in Response", statusCode: statusCode)))
            }
            
        }
        
        task.resume()
    }
}
