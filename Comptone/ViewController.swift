//
//  ViewController.swift
//  Playlist
//
//  Created by Anastasia Goncharova on 20/04/2019.
//  Copyright © 2019 Anton Goncharov. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer
import Firebase
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let applicationMusicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    var ref: DatabaseReference!
    
    var tracks = [Track]()

    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.register(UINib(nibName: "TrackCell", bundle: nil), forCellReuseIdentifier: "TrackCell")
        appleMusicRequestPermission()
        appleMusicCheckIfDeviceCanPlayback()
//       let playlistQuery = MPMediaQuery.playlists()
//        let items = playlistQuery.items
//        for item in items! {
//            print(item.playbackStoreID)
//        }
      // appleMusicPlayTrackId(ids: ["1147282519"])
        //appleMusicPlayTrackId(ids: ["1147282519", "1440873230"])
        
       // applicationMusicPlayer.prepareToPlay()
       // applicationMusicPlayer.play()
        
        ref = Database.database().reference(withPath: "playlist")
        
//        ref.observeSingleEvent(of: .value) { snapshot in
//            for child in snapshot.children {
//                let a = (child as! DataSnapshot).value as! String
//                print(a)
//            }
//        }
//        
//        
        ref.observe(.childAdded) { snapshot in
            let trackDictionary = snapshot.value as! [String: Any]
            let json = try! JSONSerialization.data(withJSONObject: trackDictionary)
            let decoder = JSONDecoder()
            let track = try! decoder.decode(Track.self, from: json)
            self.tracks.append(track)
            self.tableView.reloadData()
            self.appleMusicPlayTrackId(ids: [track.trackId])
          
       }
//
//        ref.observe(DataEventType.value, with: { (snapshot) in
//            let playlist = snapshot.value as? [String] ?? []
//            self.appleMusicPlayTrackId(ids: playlist)
//        })
    }

    @IBAction func buttonTouched(_ sender: Any) {
        guard let key = ref.childByAutoId().key else { return }
        let value = "1440873230"
        let childUpdates = ["\(key)": value]
        ref.updateChildValues(childUpdates)
    }
    
    func appleMusicCheckIfDeviceCanPlayback() {
        let serviceController = SKCloudServiceController()
        serviceController.requestCapabilities { capability, err in
            switch capability {
            case .musicCatalogPlayback:
                print("The user has an Apple Music subscription and can playback music!")
            case .musicCatalogSubscriptionEligible:
                print("Something")
            case.addToCloudMusicLibrary:
                print("The user has an Apple Music subscription, can playback music AND can add to the Cloud Music Library")
            default:
                break
            }
        }
        
        serviceController.requestStorefrontIdentifier { (identifier, error) in
            if error != nil {
                 print("Something wrong \(error)")
            }
        }
    }
    
    
    func appleMusicRequestPermission() {
        SKCloudServiceController.requestAuthorization { (status:SKCloudServiceAuthorizationStatus) in
            switch status {
            case .authorized:
                print("All good - the user tapped 'OK', so you're clear to move forward and start playing.")
            case .denied:
                print("The user tapped 'Don't allow'. Read on about that below...")
            case .notDetermined:
                print("The user hasn't decided or it's not clear whether they've confirmed or denied.")
            case .restricted:
                print("User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied.")
            }
        }
    }
    
    func appleMusicPlayTrackId(ids:[String]) {
        guard applicationMusicPlayer.nowPlayingItem == nil else {
            let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: ids)
            descriptor.startItemID = ids[0]
            applicationMusicPlayer.append(descriptor)
            return
        }
        applicationMusicPlayer.setQueue(with: ids)
        applicationMusicPlayer.prepareToPlay { _ in
            self.applicationMusicPlayer.play()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
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
