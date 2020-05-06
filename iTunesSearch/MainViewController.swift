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
        navigationController?.navigationBar.topItem?.title = "Music"
    }
    
    private func setupView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.tableFooterView = UIView(frame: .zero)
        mainTableView.separatorStyle = .none
        mainTableView.register(MediaTableViewCell.self, forCellReuseIdentifier: MediaTableViewCell.identifier)
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
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.media.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: MediaTableViewCell.identifier,
                                                       for: indexPath) as? MediaTableViewCell else { return UITableViewCell() }
        let mediaItem = viewModel.media[indexPath.row]
        
        guard let name = mediaItem.collectionName, let genre = mediaItem.primaryGenreName, let link = mediaItem.trackViewUrl, let artUrl = mediaItem.artworkUrl else { return UITableViewCell()}
        
        cell.configureCellWith(name: name, genre: genre, link: link, artUrl: artUrl)
        
        return cell
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
