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
    
    
}
