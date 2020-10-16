//
//  MovieDetailViewController.swift
//  Movie Manager
//
//  Created by Marky Jordan on 8/21/20.
//  Copyright © 2020 Marky Jordan. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK: - Outlets/Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var watchlistBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var favoritesBarButtonItem: UIBarButtonItem!
    
    var movie: Movie!
    
    var isWatchlist: Bool {
        return MovieModel.watchlist.contains(movie)
    }
    
    var isFavorite: Bool {
        return MovieModel.favorites.contains(movie)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navigation title to match the displayed movie
        navigationItem.title = movie.title
        
        
        toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        toggleBarButton(favoritesBarButtonItem, enabled: isFavorite)
    }
    
    // MARK: - Actions
    
    @IBAction func watchlistButtonTapped(_ sender: UIBarButtonItem) {
        TMDBClient.markWatchlist(movieId: movie.id, watchlist: !isWatchlist, completion: handleWatchlistResponse(success:error:))
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {

    }
    
    func toggleBarButton(_ button: UIBarButtonItem, enabled: Bool) {
        if enabled {
            button.tintColor = UIColor.primaryDark
        } else {
            button.tintColor = UIColor.gray
        }
    }
    
    // MARK: - Completion Handlers
    
    func handleWatchlistResponse(success: Bool, error: Error?) {
        if success {
            // if the movie was already on the watchlist (i.e. Bool = true),
            // pressing the mark watchlist button would successfully remove the movie from the watchlist
            if isWatchlist {
                MovieModel.watchlist = MovieModel.watchlist.filter() { $0 != self.movie }
            } else {
                MovieModel.watchlist.append(movie)
            }
            // update the bar button tint to reflect the add/removal of a movie
            toggleBarButton(watchlistBarButtonItem, enabled: isWatchlist)
        }
    }
}
