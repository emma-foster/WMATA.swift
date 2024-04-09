//
//  StopTime.swift
//
//
//  Created by Emma on 4/9/24.
//

import Foundation
import SQLite

public struct GTFSStopTime: Equatable, Hashable, Codable {
    
    /// The trip this stop occurs on
    public var tripID: GTFSIdentifier<GTFSTrip>
    
    /// The time a vehicle arrives at this ``stopID``
    ///
    /// Time occurs in the timezone defined in ``GTFSAgency/timeZone``. For WMATA, this is always `America/New_York`.
    public var arrivalTime: GTFSTime
    
    /// The time a vehicle leaves this ``stopID``
    ///
    /// Time occurs in the timezone defined in ``GTFSAgency/timeZone``. For WMATA, this is always `America/New_York`.
    public var departureTime: GTFSTime
    
    /// The stop being serviced by this stop time.
    public var stopID: GTFSIdentifier<GTFSStop>
    
    /// Order of stops, location groups, or GeoJSON locations for a particular trip. The values must increase along the trip but do not need to be consecutive.
    public var stopSequence: Int
    
    /// What kind of pickup or drop off is happening at some stop time
    public enum PickupDropOff: Int, Equatable, Hashable, Codable {
        
        /// A normal pickup or drop off
        case regularlyScheduled = 0
        
        /// No pickup or drop off available
        case notAvailable
        
        /// Must make a phone call to the transit agency to arrange this pickup or drop off
        case mustCallAgency
        
        /// Must work with the driver to arrange this pickup or drop off
        case coordinateWithDriver
    }
    
    /// How the pickup is arranged at this stop time
    public var pickupType: PickupDropOff
    
    /// How the dropoff is arranged at this stop time
    public var dropOffType: PickupDropOff
    
    /// The distance a vehicle has moved along this trip's associated ``GTFSShape`` in miles
    public var distanceTraveled: Measurement<UnitLength>
    
    /// Create a stop time by providing all of it's properties
    public init(tripID: GTFSIdentifier<GTFSTrip>, arrivalTime: GTFSTime, departureTime: GTFSTime, stopID: GTFSIdentifier<GTFSStop>, stopSequence: Int, pickupType: PickupDropOff, dropOffType: PickupDropOff, distanceTraveled: Measurement<UnitLength>) {
        self.tripID = tripID
        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
        self.stopID = stopID
        self.stopSequence = stopSequence
        self.pickupType = pickupType
        self.dropOffType = dropOffType
        self.distanceTraveled = distanceTraveled
    }
    
    /// Query the database for a unique stop time
    public init(tripID: GTFSIdentifier<GTFSTrip>, stopSequence: Int) throws {
        try self.init(where: GTFSStopTime.databaseTable.sqlTable
            .filter(TableColumn.tripID == tripID.rawValue)
            .filter(TableColumn.stopSequence == stopSequence)
        )
    }
    
    /// Query the database for a unique stop time
    public init(_ tripID: @autoclosure @escaping () -> String, stopSequence: Int) throws {
        try self.init(tripID: .init(tripID()), stopSequence: stopSequence)
    }
}

extension GTFSStopTime: GTFSStructure {
    var id: GTFSIdentifier<GTFSStopTime> {
        .init([self.tripID.rawValue, String(self.stopSequence)].joined())
    }
    
    enum TableColumn {
        static let tripID = Expression<String>("trip_id")
        static let arrivalTime = Expression<String>("arrival_time")
        static let departureTIme = Expression<String>("departure_time")
        static let stopID = Expression<String>("stop_id")
        static let stopSequence = Expression<Int>("stop_sequence")
        static let pickupType = Expression<Int>("pickup_type")
        static let dropOffType = Expression<Int>("drop_off_type")
        static let distanceTraveled = Expression<Double>("shape_dist_traveled")
    }
    
    static let databaseTable = GTFSDatabase.Table(
        sqlTable: SQLite.Table("stop_times"),
        primaryKeyColumn: TableColumn.tripID
    )
    
    init(row: Row) throws {
        self.tripID = .init(try row.get(TableColumn.tripID))
        
        guard let arrivalTime = GTFSTime(rawValue: try row.get(TableColumn.arrivalTime)) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSStopTime.self, key: "arrival_time")
        }
        
        self.arrivalTime = arrivalTime
        
        guard let departureTime = GTFSTime(rawValue: try row.get(TableColumn.departureTIme)) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSStopTime.self, key: "departure_time")
        }
        
        self.departureTime = departureTime
        
        self.stopID = .init(try row.get(TableColumn.stopID))
        self.stopSequence = try row.get(TableColumn.stopSequence)
        
        guard let pickupType = PickupDropOff(rawValue: try row.get(TableColumn.pickupType)) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSStopTime.self, key: "pickup_type")
        }
        
        self.pickupType = pickupType
        
        guard let dropOffType = PickupDropOff(rawValue: try row.get(TableColumn.dropOffType)) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSStopTime.self, key: "drop_off_type")
        }
        
        self.dropOffType = dropOffType
        
        self.distanceTraveled = .init(value: try row.get(TableColumn.distanceTraveled), unit: .miles)
    }
}
