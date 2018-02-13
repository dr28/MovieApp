//
//  Constants.swift
//  MovieApp
//
//  Created by Deepthy on 2/12/18.
//  Copyright © 2018 Deepthy. All rights reserved.
//

import Foundation

struct Constants {
    struct CellIdentifier {
        static let Portrait = "PortraitCell"
        static let LandScape = "LandscapeCell"
    }
    
    struct Trailer {
        static let BaseUrl = "https://www.youtube.com/embed/"
    }
    
    struct Poster {
        static let BaseUrl = "http://image.tmdb.org/t/p/w500"
    }
    
    struct Refresh {
        static let Name = "Pull to refresh"
    }
    
    struct ApiResource {
        static let BaseUrl = "https://api.themoviedb.org/3/movie"
        static let ApiKey = "api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        struct MoviesResource {
            static let MethodPath = "/now_playing"
        }
        struct TrailersResource {
            static let MethodPath = "/videos"
        }
        
    }
    
}
