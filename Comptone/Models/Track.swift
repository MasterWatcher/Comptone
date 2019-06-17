//
//  Track.swift
//  Comptone
//
//  Created by Anastasia Goncharova on 30/05/2019.
//  Copyright © 2019 Anton Goncharov. All rights reserved.
//

import Foundation

struct Track: Codable {
    let trackId: String
    let artistName: String
    let trackName: String
    let artworkUrl100: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let intTrackId = try? container.decode(Int.self, forKey: .trackId)
        let stringTrackId = try? container.decode(String.self, forKey: .trackId)
        trackId = intTrackId.flatMap(String.init) ?? stringTrackId!
        artistName = try container.decode(String.self, forKey: .artistName)
        trackName = try container.decode(String.self, forKey: .trackName)
        artworkUrl100 = try container.decode(String.self, forKey: .artworkUrl100)
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
