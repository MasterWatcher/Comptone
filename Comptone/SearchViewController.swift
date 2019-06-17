//
//  SearchViewController.swift
//  Comptone
//
//  Created by Anastasia Goncharova on 30/05/2019.
//  Copyright © 2019 Anton Goncharov. All rights reserved.
//

import UIKit
import Moya
import Kingfisher
import Firebase

class SearchViewController: UIViewController {
    
    let ref = Database.database().reference(withPath: "playlist")
    
    let provider = MoyaProvider<ITunesAPI>()
    var tracks = [Track]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TrackCell", bundle: nil), forCellReuseIdentifier: "TrackCell")
    }
    
    @IBAction func closeTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func findTracks(query: String) {
        provider.request(.search(term: query)) { [weak self] result in
            switch result {
            case let .success(moyaResponse):
                self?.tracks = try! moyaResponse.map([Track].self, atKeyPath: "results")
                self?.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        let track = tracks[indexPath.row]
        cell.artistNameLabel.text = track.artistName
        cell.trackNameLabel.text = track.trackName
        cell.coverImageView.kf.setImage(with: URL(string: track.artworkUrl100))
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]
        guard let key = ref.childByAutoId().key else { return }
        let childUpdates = ["\(key)": try! track.asDictionary()]
        ref.updateChildValues(childUpdates)
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        findTracks(query: query)
    }
}
