//
//  Service.swift
//
//
//  Created by Emma on 3/26/24.
//

import Foundation
import SQLite

/// Identifies a set of dates when service is available for one or more routes.
///
/// WMATA uses services to denote weekday, weekend, and any day services.
///
/// [See GTFS calendar.txt docs](https://gtfs.org/schedule/reference/#calendartxt)
///
/// ```swift
/// let service = try GTFSService("weekday_service_R")
///
/// service.monday // Service.hasService
/// service.satuday // Service.noService
/// ```
public struct GTFSService: Equatable, Hashable, Codable {
    
    /// A unique identifier for this Service
    public var id: GTFSIdentifier<GTFSService>
    
    /// If a particular day has service or not
    public enum Service: Int, Equatable, Hashable, Codable {
        
        /// There is no service on this day
        case noService = 0
        
        /// There is service on this day
        case hasService
        
    }
    
    /// If this service is available on Monday
    public var monday: Service
    
    /// If this service is available on Tuesday
    public var tuesday: Service
    
    /// If this service is available on Wednesday
    public var wednesday: Service
    
    /// If this service is available on Thursday
    public var thursday: Service
    
    /// If this service is available on Friday
    public var friday: Service
    
    /// If this service is available on Saturday
    public var saturday: Service
    
    /// If this service is available on Sunday
    public var sunday: Service
    
    public var startDate: Date
    
    public var endDate: Date
    
    /// Create a new service by providing all of it's properties
    public init(
        id: GTFSIdentifier<GTFSService>,
        monday: Service = .noService,
        tuesday: Service = .noService,
        wednesday: Service = .noService,
        thursday: Service = .noService,
        friday: Service = .noService,
        saturday: Service = .noService,
        sunday: Service = .noService,
        startDate: Date,
        endDate: Date
    ) {
        self.id = id
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
        self.sunday = sunday
        self.startDate = startDate
        self.endDate = endDate
    }
}

public extension GTFSService {
    /// Collection of service on all days, Monday thru Sunday. Can be used with [`DateComponents/weekday`](https://developer.apple.com/documentation/foundation/datecomponents/1780094-weekday)
    ///
    /// Similar to ``all``, but for older devices that do not support `Locale.Weekday`
    var allDays: [Int: Service] {
        [
            1: self.sunday,
            2: self.monday,
            3: self.tuesday,
            4: self.wednesday,
            5: self.thursday,
            6: self.friday,
            7: self.saturday
        ]
    }
    
    /// Get the service change that applies to the given date, if there is one
    func change(on date: Date) throws -> GTFSServiceChange.ChangeType? {
        let change = try? GTFSServiceChange(self.id, date)
        
        return change?.change ?? nil
    }
}

@available(tvOS 16, *)
@available(watchOS 9, *)
@available(iOS 16, *)
@available(macOS 13, *)
public extension GTFSService {
    /// Check if this service is running on the given day
    func on(_ day: Locale.Weekday) -> Service {
        switch day {
        case .sunday:
            return self.sunday
        case .monday:
            return self.monday
        case .tuesday:
            return self.tuesday
        case .wednesday:
            return self.wednesday
        case .thursday:
            return self.thursday
        case .friday:
            return self.friday
        case .saturday:
            return self.saturday
        @unknown default:
            return .noService
        }
    }
    
    /// Check if this service is running on the given day
    subscript(day: Locale.Weekday) -> Service {
        self.on(day)
    }
    
    /// Collection of service on all days, Monday thru Sunday
    var all: [Locale.Weekday: Service] {
        [
            .monday: self.monday,
            .tuesday: self.tuesday,
            .wednesday: self.wednesday,
            .thursday: self.thursday,
            .friday: self.friday,
            .saturday: self.saturday,
            .sunday: self.sunday
        ]
    }
    
    /// All days that this service runs on
    var serviceDays: [Locale.Weekday] {
        self.all.reduce(into: []) { (partialResult, service) in
            if service.value == .hasService {
                partialResult.append(service.key)
            }
        }
    }
    
    /// All days that this service does not run on
    var noServiceDays: [Locale.Weekday] {
        self.all.reduce(into: []) { (partialResult, service) in
            if service.value == .noService {
                partialResult.append(service.key)
            }
        }
    }
}

extension GTFSService: GTFSStructure {
    public enum TableColumn {
        static let id = Expression<String>("service_id")
        static let monday = Expression<Int>("monday")
        static let tuesday = Expression<Int>("tuesday")
        static let wednesday = Expression<Int>("wednesday")
        static let thursday = Expression<Int>("thursday")
        static let friday = Expression<Int>("friday")
        static let saturday = Expression<Int>("saturday")
        static let sunday = Expression<Int>("sunday")
        static let startDate = Expression<Int>("start_date")
        static let endDate = Expression<Int>("end_date")
    }
    
    static let databaseTable = GTFSDatabase.Table(
        sqlTable: SQLite.Table("calendar"),
        primaryKeyColumn: TableColumn.id
    )
    
    init(row: Row) throws {
        self.id = .init(try row.get(TableColumn.id))
                
        let monday = try row.get(TableColumn.monday)
        
        guard let monday = Service(rawValue: monday) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSService.self, key: "monday")
        }
        
        self.monday = monday
        
        let tuesday = try row.get(TableColumn.tuesday)
        
        guard let tuesday = Service(rawValue: tuesday) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSService.self, key: "tuesday")
        }
        
        self.tuesday = tuesday
        
        let wednesday = try row.get(TableColumn.wednesday)
        
        guard let wednesday = Service(rawValue: wednesday) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSService.self, key: "wednesday")
        }
        
        self.wednesday = wednesday
        
        let thursday = try row.get(TableColumn.thursday)
        
        guard let thursday = Service(rawValue: thursday) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSService.self, key: "thursday")
        }
        
        self.thursday = thursday
        
        let friday = try row.get(TableColumn.friday)
        
        guard let friday = Service(rawValue: friday) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSService.self, key: "friday")
        }
        
        self.friday = friday
        
        let saturday = try row.get(TableColumn.saturday)
        
        guard let saturday = Service(rawValue: saturday) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSService.self, key: "saturday")
        }
        
        self.saturday = saturday
        
        let sunday = try row.get(TableColumn.sunday)
        
        guard let sunday = Service(rawValue: sunday) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSService.self, key: "sunday")
        }
        
        self.sunday = sunday
        
        let startDate = try row.get(TableColumn.startDate)
        
        guard let startDate = Date(from8CharacterNumber: startDate) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSService.self, key: "start_date")
        }
        
        self.startDate = startDate
        
        let endDate = try row.get(TableColumn.endDate)
        
        guard let endDate = Date(from8CharacterNumber: endDate) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSService.self, key: "end_date")
        }
        
        self.endDate = endDate
    }
}
