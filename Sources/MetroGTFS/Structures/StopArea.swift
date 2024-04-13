//
//  StopArea.swift
//
//
//  Created by Emma on 4/6/24.
//

import Foundation
import SQLite

/// A map from ``GTFSArea`` to ``GTFSStop``
///
/// See [stop_areas.txt docs](https://gtfs.org/schedule/reference/#stop_areastxt)
///
/// ## Example
/// ```
/// let stopArea = try GTFSStopArea("everywhere", stopID: "STN_N06")
///
/// stopArea.stopID // .init("STN_N06")
/// ```
public struct GTFSStopArea: Equatable, Hashable, Codable {
    /// The area for this stop area
    public var areaID: GTFSIdentifier<GTFSArea>
    
    /// The stop for this stop area
    public var stopID: GTFSIdentifier<GTFSStop>
    
    /// Create a stop area by providing all of it's fields
    public init(areaID: GTFSIdentifier<GTFSArea>, stopID: GTFSIdentifier<GTFSStop>) {
        self.areaID = areaID
        self.stopID = stopID
    }
    
    /// Query the database for a specific stop area
    public init(_ areaID: GTFSIdentifier<GTFSArea>, stopID: GTFSIdentifier<GTFSStop>) throws {
        try self.init(areaID, stopID)
    }
    
    /// Query the database for a specific stop area
    public init(_ areaID: @autoclosure @escaping () -> String, stopID: @autoclosure @escaping () -> String) throws {
        try self.init(areaID(), stopID())
    }
    
    /// Query the database for all stop areas that match the given area or stops
    public static func all(areaID: GTFSIdentifier<GTFSArea>? = nil, stopID: GTFSIdentifier<GTFSStop>? = nil) throws -> [GTFSStopArea] {
        var query = GTFSStopArea.table
        
        if let areaID {
            query = query.filter(Expression<String>("area_id") == areaID.rawValue)
        }
        
        if let stopID {
            query = query.filter(Expression<String>("stop_id") == stopID.rawValue)
        }
        
        return try GTFSStopArea.all(where: query)
    }
}

extension GTFSStopArea: CompositeKeyQueryable {
    static let table = Table("stop_areas")
    
    init(row: Row) throws {
        self.areaID = .init(try row.get(Expression<String>("area_id")))
        self.stopID = .init(try row.get(Expression<String>("stop_id")))
    }
    
    static func createPrimaryKeyQuery<P1, P2>(_ primaryKey1: P1, _ primaryKey2: P2) -> SQLite.Table where P1 : SQLite.Value, P2 : SQLite.Value, P1.Datatype : Equatable, P2.Datatype : Equatable {
        table.filter(Expression<P1>("area_id") == primaryKey1 && Expression<P2>("stop_id") == primaryKey2)
    }
}
