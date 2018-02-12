//
//  MovieResult.swift
//  MovieApp
//
//  Created by Deepthy on 2/12/18.
//  Copyright © 2018 Deepthy. All rights reserved.
//

import Foundation
import UIKit

struct MovieResults: Codable {
    
    struct Movie : Codable {
        let id: Int?
        let overview: String?
        let title: String?
        let posterPath: String?
        
        private enum CodingKeys: String, CodingKey {
            case id
            case overview
            case title = "original_title"
            case posterPath = "poster_path"
            
        }
    }
    
    var results : [Movie] = [Movie]()
    
    init(data: Data) {
        let decoder = JSONDecoder()
        do {
            
            let movieData = try decoder.decode(MovieResults.self, from: data)
            self.results = movieData.results
        } catch let err {
            print("Err", err)
        }
        
    }
}

