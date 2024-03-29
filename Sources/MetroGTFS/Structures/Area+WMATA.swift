//
//  Area+WMATA.swift
//  
//
//  Created by Emma on 3/29/24.
//

import Foundation

#if canImport(WMATA)

import WMATA

public extension GTFSArea {
    /// Create a GTFS Area from a WMATA `Station`.
    ///
    /// - Parameters:
    ///   - station: A WMATA package station
    init(station: Station) throws {
        if let transferStations = station.allTogetherGTFSOrder {
            let idString = transferStations.map { $0.rawValue }.joined(separator: "_")
            
            self.init(id: .init("STN_\(idString)"))
            
            return
        }
        
        self.init(id: .init("STN_\(station.rawValue)"))
    }
    
    /// A physical WMATA station. Can represent a single WMATA Standard API station (intermediate stations) or multiple WMATA Standard API stations (transfer stations)
    enum PhysicalStation: Equatable, Hashable, Codable {
        /// A single WMATA Standard API station. These stations to not connect to different routes.
        ///
        /// ## Example
        /// `STN_A01` // Farragut North
        case intermediate(Station)
        
        /// Multiple WMATA Standard AI stations. These stations offer connections to different routes.
        ///
        /// ## Example
        /// `STN_A01_C01` // Metro Center Upper and Metro Center Lower
        case transfer(Station, Station)
    }
    
    /// The WMATA `Station`s that are equivalent to this GTFS Area.
    ///
    /// ## Example
    /// ```
    /// GTFSArea("STN_A02") == .intermediate(.farragutNorth)
    /// GTFSArea("STN_A01_C01") == .transfer(.metroCenterUpper, .metroCenterLower)
    /// ```
    var station: PhysicalStation? {
        guard self.id.rawValue.starts(with: "STN_") else {
            return nil
        }
        
        var stationCodes = self.id.rawValue.split(separator: "_").map(String.init)
        
        stationCodes.removeFirst() // removing `STN`
        
        let station = Station(rawValue: stationCodes.removeFirst())!
        
        if stationCodes.count == 1 {
            let transferStationCode = stationCodes.removeFirst()
            
            let transferStation = Station(rawValue: transferStationCode)!
            
            return .transfer(station, transferStation)
        }
        
        return .intermediate(station)
    }
}

public extension WMATA.Station {
    /// Combines this station and other stations within the same physical station. Order matches the order of the stations in a ``GTFSArea/id``.
    ///
    /// - Returns: This station and the `together`, if there is one.
    var allTogetherGTFSOrder: [Station]? {
        switch self {
        case .galleryPlaceLower:
            return [.galleryPlaceUpper, self]
        case .galleryPlaceUpper:
            return [self, .galleryPlaceUpper]
        case .metroCenterLower:
            return [.metroCenterUpper, self]
        case .metroCenterUpper:
            return [self, .metroCenterLower]
        case .fortTottenLower:
            return [.fortTottenUpper, self]
        case .fortTottenUpper:
            return [self, .fortTottenLower]
        case .lenfantPlazaLower:
            return [self, .fortTottenUpper]
        case .lenfantPlazaUpper:
            return [.lenfantPlazaLower, self]
        default:
            return nil
        }
    }
}

#endif
