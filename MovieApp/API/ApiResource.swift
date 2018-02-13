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
        let baseUrl = Constants.ApiResource.BaseUrl
        let apiKey = Constants.ApiResource.ApiKey
        
        let url = baseUrl + methodPath + "?" + apiKey
        
        return URL(string: url)!
    }
    
    func makeModel(data: Data) -> Model? {
        return makeModel(data: data)
    }
}

struct MoviesResource: ApiResource {
    typealias Model = MovieResults.Movie
    
    let methodPath = Constants.ApiResource.MoviesResource.MethodPath

    func makeModel(data: Data) -> [MovieResults.Movie] {
        return MovieResults(data: data).results
    }
}

struct TrailersResource: ApiResource {
    var methodPath = Constants.ApiResource.TrailersResource.MethodPath
    typealias Model = TrailerResults.Trailer

    init() {}
    
    init(movie: String) {
        methodPath = "/" + movie + methodPath
    }
    
    func makeModel(data: Data) -> [TrailerResults.Trailer] {
        return TrailerResults(data: data).results
    }
}

