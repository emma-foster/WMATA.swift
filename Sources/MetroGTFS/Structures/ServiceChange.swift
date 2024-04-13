//
//  ServiceChange.swift
//
//
//  Created by Emma on 3/28/24.
//

import Foundation
import SQLite

/// Denotes a change a ``GTFSService`` on some date.
///
/// A service may be added or removed on some dates.
///
/// [See GTFS calendar_dates.txt docs](https://gtfs.org/schedule/reference/#calendar_datestxt)
///
/// ```swift
/// let service = GTFSService("weekday_service_R")
///
/// service.change(on: 20240619) // .removed
/// service.change(on: Date()) // nil (a good day)
/// ```
public struct GTFSServiceChange: Equatable, Hashable, Codable {
    /// The ID of the ``GTFSService`` that is being modified
    public var serviceID: GTFSIdentifier<GTFSService>
    
    /// The date of the service change
    public var date: Date
    
    /// How the service can be changed on a date
    public enum ChangeType: Int, Equatable, Hashable, Codable {
        /// Service was added on this date
        case added = 1
        
        /// Service was removed on this date
        case removed = 2
    }
    
    /// How the service was changed on this date
    public var change: ChangeType
    
    /// Create a new service change by providing all of it's properties
    public init(serviceID: GTFSIdentifier<GTFSService>, date: Date, change: ChangeType) {
        self.serviceID = serviceID
        self.date = date
        self.change = change
    }
    
    /// Query the database for a unique service change
    public init(serviceID: GTFSIdentifier<GTFSService>, date: Date) throws {
        try self.init(serviceID, date.as8CharacterNumber())
    }
    
    /// Query the database for a unique service change
    public init(_ serviceID: @autoclosure @escaping () -> String, date: Date) throws {
        try self.init(serviceID(), date.as8CharacterNumber())
    }
    
    /// Query the database for a service change for the given service ID and date in GTFS format as a number
    ///
    /// ## Example
    /// ```
    /// try GTFSServiceChange(.init("weekday_service_R"), 20240619)
    /// ```
    public init(serviceID: GTFSIdentifier<GTFSService>, date: Int) throws {
        try self.init(serviceID, date)
    }
    
    /// Query the database for a service change for the given service ID and date in GTFS format as a number
    ///
    /// ## Example
    /// ```
    /// try GTFSServiceChange("weekday_service_R", 20240619)
    /// ```
    public init(_ serviceID: @autoclosure @escaping () -> String, date: Int) throws {
        try self.init(serviceID(), date)
    }
}


extension GTFSServiceChange: CompositeKeyQueryable {
    static let table = Table("calendar_dates")
    
    init(row: Row) throws {
        self.serviceID = .init(try row.get(Expression<String>("service_id")))
        
        let date = try row.get(Expression<Int>("date"))
        
        guard let date = Date(from8CharacterNumber: date) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSServiceChange.self, key: "date")
        }
        
        self.date = date
        
        let change = try row.get(Expression<Int>("exception_type"))
        
        guard let changeType = ChangeType(rawValue: change) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSServiceChange.self, key: "changeType")
        }
        
        self.change = changeType
    }
    
    static func createPrimaryKeyQuery<P1, P2>(_ primaryKey1: P1, _ primaryKey2: P2) -> Table where P1: Value, P1.Datatype: Equatable, P2: Value, P2.Datatype: Equatable {
        table.filter(Expression<P1>("service_id") == primaryKey1 && Expression<P2>("date") == primaryKey2)
    }
}
