//
//  Route.swift
//
//
//  Created by Emma on 3/24/24.
//

import Foundation
import SQLite

/// A [GTFS Route](https://gtfs.org/schedule/reference/#routestxt)
///
/// Describes transit routes that are run by some ``GTFSAgency``.
///
/// Routes are groups of `GTFSTrip`s that are displayed to riders as a single service.
///
/// ```swift
/// let route = try GTFSRoute("RED")
///
/// route.longName // "Metrorail Red Line"
/// ```
public struct GTFSRoute: Equatable, Hashable, Codable {
    /// A unique identifier for this route
    public var id: GTFSIdentifier<GTFSRoute>
    
    /// The identifier for the ``GTFSAgency`` that runs this route.
    public var agencyID: GTFSIdentifier<GTFSAgency>
    
    /// Short name of this route. Usually an identifier. For Metrorail service, this is the color of the line. Example: `RED`
    public var shortName: String
    
    /// A descriptive name for this route. For WMATA Metrorail service, this looks like `Metrorail Red Line`.
    public var longLame: String?
    
    /// The type of transportation used on this route
    public enum RouteType: Int, Equatable, Hashable, Codable, CaseIterable {
        /// Tram, Streetcar, Light rail. Any light rail or street level system within a metropolitan area.
        case lightRail = 0
        
        /// An alias for ``lightRail``
        static let tram = RouteType.lightRail
        
        /// An alias for ``lightRail``
        static let streetcar = RouteType.lightRail
        
        /// Any underground rail system within a metropolitan area.
        case metro
        
        /// An alias for ``metro``
        static let subway = RouteType.metro
        
        ///  Used for intercity or long-distance travel.
        case rail
        
        /// Used for short- and long-distance bus routes.
        case bus
        
        /// Used for short- and long-distance boat service.
        case ferry
        
        /// Used for street-level rail cars where the cable runs beneath the vehicle (e.g., cable car in San Francisco).
        case cableTram
        
        /// Cable transport where cabins, cars, gondolas or open chairs are suspended by means of one or more cables.
        case aerialLift
        
        /// An alias for ``aerialLift``
        static let suspendedCableCar = RouteType.aerialLift
        
        /// An alias for ``aerialLift``
        static let gondola = RouteType.aerialLift
        
        /// An alias for ``aerialLift``
        static let gondolaLift = RouteType.aerialLift
        
        /// An alias for ``aerialLift``
        static let aerialTramway = RouteType.aerialLift
        
        /// Any rail system designed for steep inclines.
        case funicular
        
        /// Electric buses that draw power from overhead wires using poles.
        case trolleybus
        
        /// Railway in which the track consists of a single rail or a beam.
        case monorail
    }
    
    /// The type of transportation used on this route. For WMATA, this is ``RouteType/metro`` for Metrorail and ``RouteType/bus`` for buses and shuttles.
    public var routeType: RouteType
    
    /// URL of a web page about the particular route. Different than the agency URL. Unused by WMATA.
    public var url: URL?
    
    /// The hex color of the route.
    ///
    /// If you are using SwiftUI, UIKit or AppKit, this color is available as ``color``, ``uiColor`` or  ``nsColor``
    public var hexColor: String
    
    /// The hex color of the route. Has high contrast with ``hexColor``.
    ///
    /// If you are using SwiftUI, UIKit or AppKit, this color is available as ``textColor``, ``uiTextColor`` or ``nsTextColor``
    public var hexTextColor: String
    
    ///  Indicates if ``GTFSRoute`` within a single ``GTFSNetwork`` behaves as one route for fare purposes.
    public enum AsRoute: Int, Equatable, Hashable, Codable {
        /// One-route behavior is not enabled. Transferring between different routes in the same network incurs a fare.
        case multipleRoutes = 0
        
        /// One-route behavior is enabled. Transferring between different routes does not incur a fare.
        case oneRoute
    }
    
    /// Indicates if transfering between different routes in the same ``GTFSNetwork`` incurs a fare.
    ///
    /// Experimental field. Subject to change.
    public var asRoute: AsRoute
    
    /// The ID of the ``GTFSNetwork`` this route is a part of.
    public var networkID: GTFSIdentifier<GTFSNetwork>
    
    /// The ``GTFSNetwork`` this route is a part of.
    public var network: GTFSNetwork {
        GTFSNetwork(id: networkID)
    }
    
    /// Create a new route by provided all of it's fields
    public init(id: GTFSIdentifier<GTFSRoute>, agencyID: GTFSIdentifier<GTFSAgency>, shortName: String, longLame: String? = nil, routeType: RouteType, url: URL? = nil, hexColor: String, hexTextColor: String, asRoute: AsRoute, networkID: GTFSIdentifier<GTFSNetwork>) {
        self.id = id
        self.agencyID = agencyID
        self.shortName = shortName
        self.longLame = longLame
        self.routeType = routeType
        self.url = url
        self.hexColor = hexColor
        self.hexTextColor = hexTextColor
        self.asRoute = asRoute
        self.networkID = networkID
    }
}

extension GTFSRoute: SimpleQueryable {
    static let primaryKeyColumn = Expression<String>("route_id")
    
    static let table = Table("routes")
    
    // Create a Route from a row in the GTFS database's `routes` table
    init(row: Row) throws {
        self.id = .init(try row.get(Expression<String>("route_id")))
        self.agencyID = .init(try row.get(Expression<String>("agency_id")))
        self.shortName = try row.get(Expression<String>("route_short_name"))
        self.longLame = try row.get(Expression<String?>("route_long_name"))
        
        guard let routeType = RouteType(rawValue: try row.get(Expression<Int>("route_type"))) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSRoute.self, key: "routeType")
        }
        
        self.routeType = routeType
        
        let url = try row.get(Expression<String?>("route_url"))
        
        if let url {
            self.url = URL(string: url)
        } else {
            self.url = nil
        }
                
        self.hexColor = try row.get(Expression<String?>("route_color")) ?? "FFFFFF"
        self.hexTextColor = try row.get(Expression<String?>("route_text_color")) ?? "000000"
        self.networkID = .init(try row.get(Expression<String>("network_id")))
        
        // TODO: Get `as_route` field into GTFS database. Currently, it's missing. Likely because `as_route` is an experimental field. So, this is hard coded to the value WMATA provides for all routes.
        self.asRoute = .oneRoute
    }
}
