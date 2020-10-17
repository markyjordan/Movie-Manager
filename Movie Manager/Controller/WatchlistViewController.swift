//
//  WatchlistViewController.swift
//  Movie Manager
//
//  Created by Marky Jordan on 8/21/20.
//  Copyright © 2020 Marky Jordan. All rights reserved.
//

import UIKit

class WatchlistViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TMDBClient.getWatchlist() { movies, error in
            MovieModel.watchlist = movies
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as! MovieDetailViewController
            detailVC.movie = MovieModel.watchlist[selectedIndex]
        }
    }
}

// MARK: - UITableView Delegate and Data Source Methods

extension WatchlistViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieModel.watchlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell")!
        
        let movie = MovieModel.watchlist[indexPath.row]
        
        cell.textLabel?.text = movie.title
        if let posterPath = movie.posterPath {
            TMDBClient.downloadPosterImage(path: posterPath) { (data, error) in
                guard let data = data else {
                    return
                }
                // convert the retrieved data into a UIImage type
                let image = UIImage(data: data)
                
                // set the cell's image view property to the image data retrieved
                cell.imageView?.image = image
                
                // force the table view image view to update its contents
                cell.setNeedsLayout()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
