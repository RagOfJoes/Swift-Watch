//
//  Cache.swift
//  TellySearch
//
//  Created by Victor Ragojos on 9/24/20.
//  Copyright © 2020 Victor Ragojos. All rights reserved.
//

import Cache
import Foundation

struct C {
    // The maximum number of objects in memory the cache should hold
    private static let CountLimit: UInt = 50
    // The maximum total cost that the cache can hold before it starts evicting objects
    private static let TotalCostLimit: UInt = 0
    // Expire objects in 3 hours
    private static let Expiration: Expiry = .date(Date().addingTimeInterval(3600 * 3))
    
    static let Show = try? Storage<String, ShowDetail>(
        diskConfig: DiskConfig(name: "ShowDetail"),
        memoryConfig: MemoryConfig(
            expiry: C.Expiration,
            countLimit: C.CountLimit,
            totalCostLimit: C.TotalCostLimit
        ), transformer: TransformerFactory.forCodable(ofType: ShowDetail.self)
    )
    
    static let Season = try? Storage<String, SeasonDetail>(
        diskConfig: DiskConfig(name: "SeasonDetail"),
        memoryConfig: MemoryConfig(
            expiry: C.Expiration,
            countLimit: C.CountLimit,
            totalCostLimit: C.TotalCostLimit
        ), transformer: TransformerFactory.forCodable(ofType: SeasonDetail.self)
    )
    
    static let Movie = try? Storage<String, MovieDetail>(
        diskConfig: DiskConfig(name: "MovieDetail"),
        memoryConfig: MemoryConfig(
            expiry: C.Expiration,
            countLimit: C.CountLimit,
            totalCostLimit: C.TotalCostLimit
        ), transformer: TransformerFactory.forCodable(ofType: MovieDetail.self)
    )
    
    static let Person = try? Storage<String, PersonDetail>(
        diskConfig: DiskConfig(name: "PersonDetail"),
        memoryConfig: MemoryConfig(
            expiry: C.Expiration,
            countLimit: C.CountLimit,
            totalCostLimit: C.TotalCostLimit
        ), transformer: TransformerFactory.forCodable(ofType: PersonDetail.self)
    )
}
