//
//  Timeframe.swift
//
//
//  Created by Emma on 3/29/24.
//

import Foundation
import SQLite

/// How fares change throughout the day. More details at [timeframes.txt](https://gtfs.org/schedule/reference/#timeframestxt)
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
    ///
    /// - Warning
    /// The date associated with this `Date` is not relevant. Only reference the time.
    public var startTime: Date
    
    /// The time in a day this fare timegroup ends
    ///
    /// - Warning
    /// The date associated with this `Date` is not relevant. Only reference the time.
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

extension GTFSTimeframe: SimpleQueryable { // TODO: make basic Queryable instead
    static let table = Table("timeframes")
    
    static let primaryKeyColumn = Expression<String>("timeframe_group_id")
    
    init(row: Row) throws {
        self.id = .init(try row.get(Expression<String>("timeframe_group_id")))
        
        let startTime = try row.get(Expression<String>("start_time"))
        var endTime = try row.get(Expression<String>("end_time"))
        
        if endTime == "24:00:00" {
            endTime = "23:59:59"
        }
        
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
        
        self.serviceID = .init(try row.get(Expression<String>("service_id")))
    }
}
