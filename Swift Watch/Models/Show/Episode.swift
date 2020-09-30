//
//  Episode.swift
//  Swift Watch
//
//  Created by Victor Ragojos on 9/29/20.
//  Copyright © 2020 Victor Ragojos. All rights reserved.
//

import Foundation

struct Episode: Codable {
    let number: Int
    let name: String
    let crew: [Crew]
    let airDate: String?
    let overview: String
    let backdrop: String?
    let guestStars: [Cast]?
    
    enum CodingKeys: String, CodingKey {
        case name
        case crew
        case overview
        case airDate = "air_date"
        case backdrop = "still_path"
        case number = "episode_number"
        case guestStars = "guest_stars"
    }
}
