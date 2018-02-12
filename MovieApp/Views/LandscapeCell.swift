//
//  LandscapeCell.swift
//  MovieApp
//
//  Created by Deepthy on 2/12/18.
//  Copyright © 2018 Deepthy. All rights reserved.
//

import UIKit
import WebKit

class LandscapeCell: UITableViewCell {
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieTrailerView: WKWebView!
    
    var movie : MovieResults.Movie? {
        didSet{
            movieTitle.text = movie?.title
            movieOverview.text = movie?.overview
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        movieTitle.text = ""
        movieOverview.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
