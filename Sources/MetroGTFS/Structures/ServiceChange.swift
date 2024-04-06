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
    
    /// Query the database for a service change for the given service ID and date.
    public init(serviceID: GTFSIdentifier<GTFSService>, date: Date) throws {
        try self.init(where: GTFSServiceChange.databaseTable.sqlTable
            .filter(TableColumn.serviceID == serviceID.rawValue)
            .filter(TableColumn.date == date.as8CharacterNumber())
        )
    }
    
    /// Query the database for a service change for the given service ID and date.
    public init(_ serviceID: @autoclosure @escaping () -> String, date: Date) throws {
        try self.init(serviceID: .init(serviceID()), date: date)
    }
    
    /// Query the database for a service change for the given service ID and date.
    public init(serviceID: GTFSIdentifier<GTFSService>, date: Int) throws {
        try self.init(where: GTFSServiceChange.databaseTable.sqlTable
            .filter(TableColumn.serviceID == serviceID.rawValue)
            .filter(TableColumn.date == date)
        )
    }
    
    /// Query the database for a service change for the given service ID and date.
    public init(_ serviceID: @autoclosure @escaping () -> String, date: Int) throws {
        try self.init(serviceID: .init(serviceID()), date: date)
    }
}

extension GTFSServiceChange: GTFSStructure {
    var id: GTFSIdentifier<GTFSServiceChange> {
        .init("\(self.serviceID), \(self.date.as8CharacterString())")
    }
    
    enum TableColumn {
        static let serviceID = Expression<String>("service_id")
        static let date = Expression<Int>("date")
        static let change = Expression<Int>("exception_type")
    }
    
    static let databaseTable = GTFSDatabase.Table(
        sqlTable: SQLite.Table("calendar_dates"),
        primaryKeyColumn: TableColumn.serviceID
    )
    
    init(row: Row) throws {
        self.serviceID = .init(try row.get(TableColumn.serviceID))
        
        let date = try row.get(TableColumn.date)
        
        guard let date = Date(from8CharacterNumber: date) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSServiceChange.self, key: "date")
        }
        
        self.date = date
        
        let change = try row.get(TableColumn.change)
        
        guard let changeType = ChangeType(rawValue: change) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSServiceChange.self, key: "changeType")
        }
        
        self.change = changeType
    }
}
