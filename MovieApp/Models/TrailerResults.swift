//
//  TrailerResults.swift
//  MovieApp
//
//  Created by Deepthy on 2/12/18.
//  Copyright © 2018 Deepthy. All rights reserved.
//

import Foundation
import UIKit

struct TrailerResults: Codable {
    struct Trailer : Codable {
        let key: String?
        let name: String?
        let site: String?
        
        private enum CodingKeys: String, CodingKey {
            case key
            case name
            case site
        }
    }
    var results : [Trailer] = [Trailer]()
    
    init(data: Data) {
        let decoder = JSONDecoder()
        do {
            let trailerData = try decoder.decode(TrailerResults.self, from: data)
            self.results = trailerData.results
        } catch let err {
            print("Err", err)
        }
    }
}
