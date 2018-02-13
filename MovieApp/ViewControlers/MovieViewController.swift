//
//  MovieViewController.swift
//  MovieApp
//
//  Created by Deepthy on 2/12/18.
//  Copyright © 2018 Deepthy. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private var movies = [MovieResults.Movie]()
    private let imageCache = NSCache<NSString, UIImage>()
    private let trailerCache = NSCache<NSString, AnyObject>()
    private let refreshControl = UIRefreshControl()
    private var request: AnyObject?
    private var reloadFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        searchBar.delegate = self
        
        // set up the refresh control
        refreshControl.attributedTitle = NSAttributedString(string: Constants.Refresh.Name)
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        fetchMovies()

        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            
            self.tableView.reloadData()
            
        }, completion: .none)
        
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    func fetchMovies() {
        
        let moviesResource = MoviesResource()
        let moviesRequest = ApiRequest(resource: moviesResource)
        self.request = moviesRequest
        
        moviesRequest.load { [weak self] (movieList: [MovieResults.Movie]?) in
            self?.movies = []
            
            for movie in movieList! {
                self?.movies.append(movie)
            }
            
            self?.tableView.reloadData()
        }
    }
    
    func fetchPoster(for url: String, posterImgView: UIImageView) {
        let imgUrl = Constants.Poster.BaseUrl + url
        
        guard let posterURL = URL(string: imgUrl) else {
            return
        }
        let posterRequest = ImageRequest(url: posterURL)
        self.request = posterRequest
        
        posterRequest.load(withCompletion: { [weak self] (poster: UIImage?) in
            
            guard let poster = poster else {
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                self?.imageCache.setObject(poster, forKey: url as NSString)
                posterImgView.image = poster
                self?.tableView.reloadData()
                
            })
        })
    }
    
    func fetchTrailer(movieID: Int, cell : LandscapeCell) {
        let trailerResource = TrailersResource(movie: String(movieID))
        let trailerRequest = ApiRequest(resource: trailerResource)
        self.request = trailerRequest
        
        trailerRequest.load { [weak self] (trailerList: [TrailerResults.Trailer]?) in
            guard trailerList != nil else {
                return
            }
            
            let path = Constants.Trailer.BaseUrl
            var url = URL(string: path)
            
            if let trailer = trailerList?.first {
                url = URL(string: path + (trailer.key)!)
            }
           
            DispatchQueue.main.async(execute: { () -> Void in
                
                cell.movieTrailerView.load(URLRequest(url: url!))
                self?.trailerCache.setObject(cell.movieTrailerView.url as AnyObject, forKey: String(movieID) as NSString)
                
                if !(self?.reloadFlag)! {
                    self?.tableView.reloadData()
                    self?.reloadFlag = !(self?.reloadFlag)!
                    
                }
            })
        }
    }
}

extension MovieViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UIDevice.current.orientation.isPortrait {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.Portrait, for: indexPath) as! PortraitCell
            cell.movie = movies[indexPath.row]
            
            let posterpath = self.movies[indexPath.row].posterPath!
            // Poster in cache
            if let cachedImage = imageCache.object(forKey: posterpath as NSString) {
                cell.moviePosterImage.image = cachedImage
            } else { // Poster not in cache
                self.fetchPoster(for: posterpath, posterImgView: cell.moviePosterImage)
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.LandScape, for: indexPath) as! LandscapeCell
            cell.movie = movies[indexPath.row]
            
            let movieID = String(movies[indexPath.row].id!)
            
            // Trailer path in cache
            if let cachedTrailer = trailerCache.object(forKey: movieID as NSString) {
                cell.movieTrailerView.load(URLRequest(url: cachedTrailer as! URL))
            } else { // Trailer path not in cache
                self.fetchTrailer(movieID: self.movies[indexPath.row].id!, cell: cell)
            }
            
            return cell
        }
    }
}

extension MovieViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchMovies()
            searchBar.resignFirstResponder()
            
        } else {
            filterTableView(text: searchText)
        }
    }
    
    private func filterTableView(text: String) {
        
        let filteredMovies = movies.filter({ (movie: MovieResults.Movie) -> Bool in
            
            let matchFound = movie.title?.lowercased().contains(text.lowercased())
            return matchFound!
        })
        
        if filteredMovies.count != 0 {
            movies = filteredMovies
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        
        searchBar.endEditing(true)
    }
}
