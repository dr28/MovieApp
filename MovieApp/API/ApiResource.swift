//
//  ApiResource.swift
//  MovieApp
//
//  Created by Deepthy on 2/12/18.
//  Copyright © 2018 Deepthy. All rights reserved.
//
import Foundation

protocol ApiResource {
    associatedtype Model
    var methodPath: String { get }
    func makeModel(data: Data) -> [Model]
}

extension ApiResource {
    var url: URL {
        let baseUrl = Constants.ApiResource.BaseUrl //"https://api.themoviedb.org/3/movie"
        let apiKey = Constants.ApiResource.ApiKey //"api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
        let url = baseUrl + methodPath + "?" + apiKey
        
        return URL(string: url)!
    }
    
    func makeModel(data: Data) -> Model? {
        return makeModel(data: data)
    }
}

struct MoviesResource: ApiResource {
    typealias Model = MovieResults.Movie
    
    let methodPath = Constants.ApiResource.MoviesResource.MethodPath //"/now_playing"

    func makeModel(data: Data) -> [MovieResults.Movie] {
        return try! MovieResults(data: data).results
    }
}

struct TrailersResource: ApiResource {
    var methodPath = Constants.ApiResource.TrailersResource.MethodPath //"/videos"
    typealias Model = TrailerResults.Trailer

    init() {}
    
    init(movie: String) {
        methodPath = "/" + movie + methodPath
    }
    
    func makeModel(data: Data) -> [TrailerResults.Trailer] {
        return try! TrailerResults(data: data).results
    }
}

