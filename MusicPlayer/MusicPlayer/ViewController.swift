//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Nathan Jamrog on 2024-04-18.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UICollectionViewDataSource, UITableViewDataSource {
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var music: Music!
    
    var searchResults: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self // Set table view data source
        collectionView.dataSource = self
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchForAlbums(with: searchText)
        }
    }
    
    // MARK: - Search Operation
    
    func searchForAlbums(with searchTerm: String) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&media=music"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let searchResult = try decoder.decode(SearchResult.self, from: data)
                    
                    self.searchResults = searchResult.results
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData() // Reload table view with new data
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let music = searchResults[indexPath.row]
        cell.musicTitle.text = music.albumName
        cell.musicCreatorName.text = music.artistName
        cell.musicImage.image = UIImage(named: music.artworkUrl100)
        return cell
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        // let music = searchResults[indexPath.item]
        // Configure the cell with music information
        // For example: cell.titleLabel.text = music.title
        return cell
    }
}

struct SearchResult: Codable {
    let results: [Music]
}
