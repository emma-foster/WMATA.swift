//
//  Trip.swift
//
//
//  Created by Emma on 4/6/24.
//

import Foundation
import SQLite

/// A single trip along a ``GTFSRoute``.
///
/// [See trips.txt docs](https://gtfs.org/schedule/reference/#tripstxt)
///
/// ```
/// let trip = try GTFSTrip("5570325_19799")
///
/// trip.headway // "GLENMONT"
/// ```
public struct GTFSTrip: Equatable, Hashable, Codable {
    /// A unique identifier for this trip
    public var id: GTFSIdentifier<GTFSTrip>
    
    /// A unique identifier for the ``GTFSRoute`` this trip runs along
    public var routeID: GTFSIdentifier<GTFSRoute>
    
    /// A unique identifier for the ``GTFSService`` that represents the set of dates this service is available for this route.
    public var serviceID: GTFSIdentifier<GTFSService>
    
    /// Text that appears on signage identifying the trip's destination to riders.
    public var headsign: String?
    
    /// Indicates the direction of travel for a trip
    public enum Direction: Int, Equatable, Hashable, Codable {
        /// Travel in one direction (e.g. outbound travel).
        case oneDirection = 0
        
        /// Travel in the opposite direction (e.g. inbound travel).
        case oppositeDirection
    }
    
    /// Indicates the direction of travel for a trip. This field should not be used in routing; it provides a way to separate trips by direction when publishing time tables.
    public var direction: Direction
    
    /// Identifies the block to which the trip belongs. A block consists of a single trip or many sequential trips made using the same vehicle, defined by shared service days and `block`. A `block` may have trips with different service days, making distinct blocks.
    ///
    /// Unused by WMATA.
    public var block: String?
    
    /// A unique ID for the ``GTFSShape`` representating a geospatial shape of the vehicle travel path for a trip.
    public var shapeID: GTFSIdentifier<GTFSShape>
    
    /// Create a new trip by providing all of it's properties
    public init(id: GTFSIdentifier<GTFSTrip>, routeID: GTFSIdentifier<GTFSRoute>, serviceID: GTFSIdentifier<GTFSService>, headsign: String? = nil, direction: Direction, block: String? = nil, shapeID: GTFSIdentifier<GTFSShape>) {
        self.id = id
        self.routeID = routeID
        self.serviceID = serviceID
        self.headsign = headsign
        self.direction = direction
        self.block = block
        self.shapeID = shapeID
    }
}

extension GTFSTrip: SimpleQueryable {
    static let table = SQLite.Table("trips")
    
    static let primaryKeyColumn = Expression<String>("trip_id")
    
    init(row: Row) throws {
        self.routeID = .init(try row.get(Expression<String>("route_id")))
        self.serviceID = .init(try row.get(Expression<String>("service_id")))
        self.id = .init(try row.get(Expression<String>("trip_id")))
        self.headsign = try row.get(Expression<String?>("trip_headsign"))
        
        guard let direction = Direction(rawValue: try row.get(Expression<Int>("direction_id"))) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSTrip.self, key: "direction_id")
        }
        
        self.direction = direction
        
        let block = try row.get(Expression<String?>("block_id"))
        
        if let block, block != "" {
            self.block = block
        }
        
        self.shapeID = .init(try row.get(Expression<String>("shape_id")))
    }
}
