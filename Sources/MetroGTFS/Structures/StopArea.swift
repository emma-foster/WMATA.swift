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
        try self.init(where: GTFSStopArea.databaseTable.sqlTable
            .filter(TableColumn.areaID == areaID.rawValue)
            .filter(TableColumn.stopID == stopID.rawValue)
        )
    }
    
    /// Query the database for a specific stop area
    public init(_ areaID: @autoclosure @escaping () -> String, stopID: @autoclosure @escaping () -> String) throws {
        try self.init(.init(areaID()), stopID: .init(stopID()))
    }
    
    /// Query the database for all stop areas that match the given area or stops
    public static func all(areaID: GTFSIdentifier<GTFSArea>? = nil, stopID: GTFSIdentifier<GTFSStop>? = nil) throws -> [GTFSStopArea] {
        var query = GTFSStopArea.databaseTable.sqlTable
        
        if let areaID {
            query = query.filter(TableColumn.areaID == areaID.rawValue)
        }
        
        if let stopID {
            query = query.filter(TableColumn.stopID == stopID.rawValue)
        }
        
        return try GTFSStopArea.all(where: query)
    }
}

extension GTFSStopArea: GTFSStructure {
    var id: GTFSIdentifier<GTFSStopArea> {
        .init("\(areaID.rawValue) \(stopID.rawValue)")
    }
    
    enum TableColumn {
        static let areaID = Expression<String>("area_id")
        static let stopID = Expression<String>("stop_id")
    }
    
    static let databaseTable = GTFSDatabase.Table(
        sqlTable: Table("stop_areas"),
        primaryKeyColumn: TableColumn.areaID
    )
    
    init(row: Row) throws {
        self.areaID = .init(try row.get(TableColumn.areaID))
        self.stopID = .init(try row.get(TableColumn.stopID))
    }
}
