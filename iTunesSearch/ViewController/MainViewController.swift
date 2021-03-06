//
//  SearchViewController.swift
//  iTunesSearch
//
//  Created by Consultant on 5/6/20.
//  Copyright © 2020 Avellaneda. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var mainTableView: UITableView!
    
    let viewModel = MediaViewModel()
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        searchSetup()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "iTunes"
    }
    
    private func setupView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.tableFooterView = UIView(frame: .zero)
        mainTableView.separatorStyle = .none
        viewModel.delegate = self
        viewModel.fetchMedia(with: "future")
    }
    
    private func searchSetup()
    {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keys = viewModel.orderedMedia.keys.sorted(by: { $0 < $1 })
        return keys[section]
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getMediaSectionCount(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: MediaTableViewCell.identifier,
                                                       for: indexPath) as? MediaTableViewCell else { return UITableViewCell() }

        guard let mediaItem = viewModel.getOrderedMedia(from: indexPath.section, at: indexPath.row) else { return cell }
        guard let name = mediaItem.collectionName, let genre = mediaItem.primaryGenreName, let link = mediaItem.trackViewUrl, let artUrl = mediaItem.artworkUrl, let id = mediaItem.trackId, let fav = mediaItem.isFavorite else { return UITableViewCell()}
        
        cell.favoriteDelegate = self
        cell.configureCellWith(name: name, genre: genre, link: link, artUrl: artUrl, trackId: id, favorite: fav)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getOrderedMediaKeysCount()
    }
    
}

extension MainViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let search = searchBar.text,
            let sanitized = search.replacingOccurrences(of: " ", with: "+").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return }
        viewModel.fetchMedia(with: sanitized)
    }
}

extension MainViewController: MediaUpdateDelegate {
    func updateView() {
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
}

extension MainViewController: FavoriteService {
    func addToFavorites(id: Int) {
        print("added to favorites \(id)")
        viewModel.addToFavorites(id: id)
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
    func removeFromFavorites(id: Int) {
        print("removed from favorites \(id)")
        viewModel.removeFromFavorites(id: id)
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
    
}
