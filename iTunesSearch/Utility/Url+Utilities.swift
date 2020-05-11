//
//  Url+Utilities.swift
//  iTunesSearch
//
//  Created by Consultant on 5/8/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import UIKit

extension URL {
    func getImage(completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: self) { (data, _, error) in
            
            if let error = error {
                print("Error Fetching Image: \(error.localizedDescription)")
                completion(nil)
            } else if let data = data {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            }
        }.resume()
    }
}
