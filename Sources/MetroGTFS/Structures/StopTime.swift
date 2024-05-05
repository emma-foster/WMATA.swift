//
//  StopTime.swift
//
//
//  Created by Emma on 4/9/24.
//

import Foundation
import SQLite

// TODO: Document
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
        try self.init(tripID, stopSequence)
    }
    
    /// Query the database for a unique stop time
    public init(_ tripID: @autoclosure @escaping () -> String, stopSequence: Int) throws {
        try self.init(tripID(), stopSequence)
    }
}

extension GTFSStopTime: CompositeKeyQueryable {
    static func createPrimaryKeyQuery<P1, P2>(_ primaryKey1: P1, _ primaryKey2: P2) -> SQLite.Table where P1 : SQLite.Value, P2 : SQLite.Value, P1.Datatype : Equatable, P2.Datatype : Equatable {
        table.filter(Expression<P1>("trip_id") == primaryKey1 && Expression<P2>("stop_sequence") == primaryKey2)
    }
    
    static let table = SQLite.Table("stop_times")
    
    init(row: Row) throws {
        self.tripID = .init(try row.get(Expression<String>("trip_id")))
        
        guard let arrivalTime = GTFSTime(rawValue: try row.get(Expression<String>("arrival_time"))) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSStopTime.self, key: "arrival_time")
        }
        
        self.arrivalTime = arrivalTime
        
        guard let departureTime = GTFSTime(rawValue: try row.get(Expression<String>("departure_time"))) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSStopTime.self, key: "departure_time")
        }
        
        self.departureTime = departureTime
        
        self.stopID = .init(try row.get(Expression<String>("stop_id")))
        self.stopSequence = try row.get(Expression<Int>("stop_sequence"))
        
        guard let pickupType = PickupDropOff(rawValue: try row.get(Expression<Int>("pickup_type"))) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSStopTime.self, key: "pickup_type")
        }
        
        self.pickupType = pickupType
        
        guard let dropOffType = PickupDropOff(rawValue: try row.get(Expression<Int>("drop_off_type"))) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSStopTime.self, key: "drop_off_type")
        }
        
        self.dropOffType = dropOffType
        
        self.distanceTraveled = .init(value: try row.get(Expression<Double>("shape_dist_traveled")), unit: .miles)
    }
}
