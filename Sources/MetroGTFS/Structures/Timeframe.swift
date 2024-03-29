//
//  Timeframe.swift
//
//
//  Created by Emma on 3/29/24.
//

import Foundation
import SQLite

/// How fares change throughout the day. More details at [timeframes.txt](https://gtfs.org/schedule/reference/#timeframestxt).
///
/// ## Example
///
///```
///let timeframe = GTFSTimeframe("weekday_regular")
///
///timeframe.startTime // the time this fare timegroup starts
///```
public struct GTFSTimeframe: Equatable, Hashable, Codable {
    
    /// A unique ID for this Timeframe Group.
    ///
    /// ## Example
    ///
    /// ```
    /// "weekday_regular"
    /// "weekday_flat"
    /// "weekday_late_night_flat"
    /// "weekend"
    /// ```
    public var id: GTFSIdentifier<GTFSTimeframe>
    
    /// The time in a day this fare timegroup starts
    public var startTime: Date
    
    /// The time in a day this fare timegroup ends
    public var endTime: Date
    
    /// The ``GTFSService`` this fare timegroup applies to.
    public var serviceID: GTFSIdentifier<GTFSService>
    
    /// Create a new fare timegroup by providing all of it's properties
    public init(id: GTFSIdentifier<GTFSTimeframe>, startTime: Date, endTime: Date, serviceID: GTFSIdentifier<GTFSService>) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.serviceID = serviceID
    }
}

extension GTFSTimeframe: GTFSStructure {
    enum TableColumn {
        static let id = Expression<String>("timeframe_group_id")
        static let startTime = Expression<String>("start_time")
        static let endTime = Expression<String>("end_time")
        static let serviceID = Expression<String>("service_id")
    }
    
    static let databaseTable = GTFSDatabase.Table(
        sqlTable: SQLite.Table("timeframes"),
        primaryKeyColumn: TableColumn.id
    )
    
    init(row: Row) throws {
        self.id = .init(try row.get(TableColumn.id))
        
        let startTime = try row.get(TableColumn.startTime)
        let endTime = try row.get(TableColumn.endTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        guard let startTime = dateFormatter.date(from: startTime) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSTimeframe.self, key: "start_time")
        }
        
        guard let endTime = dateFormatter.date(from: endTime) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSTimeframe.self, key: "end_time")
        }
        
        self.startTime = startTime
        self.endTime = endTime
        
        self.serviceID = .init(try row.get(TableColumn.serviceID))
    }
}
