//
//  GTFSLevel.swift
//
//
//  Created by Emma on 11/25/23.
//

import Foundation
import SQLite

/// A [GTFS Level](https://gtfs.org/schedule/reference/#levelstxt)
///
/// Describes the different physical levels and floors in a station. Can be used with pathways to navigate stations.
///
/// ```
/// let level = try GTFSLevel("B05_L1")
///
/// level.name // "Mezzanine"
/// ```
public struct GTFSLevel: Equatable, Hashable, Codable {
    /// A unique identifer for the level.
    public var id: GTFSIdentifier<GTFSLevel>
    
    /// Numeric index of the level that indicates its relative position.
    ///
    /// For WMATA, these are integers between -3 and 2.
    ///
    /// Ground level should have index 0, with levels above ground indicated by positive indices and levels below ground by negative indices.
    public var index: Int
    
    /// Name of the level as seen by the rider inside the building or station.
    public var name: String
    
    /// Create a new GTFS Level by providing all of it's fields
    public init(id: GTFSIdentifier<GTFSLevel>, index: Int, name: String) {
        self.id = id
        self.index = index
        self.name = name
    }
}

extension GTFSLevel: SimpleQueryable {
    static let primaryKeyColumn = Expression<String>("level_id")
    
    static let table = Table("levels")
    
    /// Create a Level from a database row from the `levels` table
    init(row: Row) throws {
        self.id = .init(try row.get(Expression<String>("level_id")))
        self.index = Int(try row.get(Expression<Double>("level_index")))
        self.name = try row.get(Expression<String>("level_name"))
    }
}
