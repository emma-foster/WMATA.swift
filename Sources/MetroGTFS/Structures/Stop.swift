//
//  GTFSStop.swift
//
//
//  Created by Emma on 11/25/23.
//

import Foundation
import SQLite

/// A [GTFS Stop](https://gtfs.org/schedule/reference/#stopstxt).
///
/// For MetroRail, represents a Station, Platform, Entrance, locations between one of the previous stops like an elevator, escalator, or the paid and unpaid sides of a faregate.
///
/// ```swift
/// let stop = try GTFSStop("STN_N12")
///
/// stop.name // "ASHBURN METRORAIL STATION"
/// ```
public struct GTFSStop: Equatable, Hashable, Codable {
    /// The unique ID for this stop
    ///
    /// Identifies a location: stop/platform, station, entrance/exit, generic node or boarding area (see `location_type`).
    ///
    /// Multiple routes may use the same `id`.
    ///
    /// ## Examples
    /// - `STN_N12` -  Ashburn station
    /// - `STN_D03_F03` - L'Enfant Plaza station
    /// - `PLF_B05_RD_SHADY_GROVE` - Platform at Brookland-CUA on the Red Line to Shady Grove
    ///
    /// ## Notes
    /// - For transfer stations, both `Station` IDs are included. Example: `STN_D03_F03`.
    public var id: GTFSIdentifier<GTFSStop>
    
    /// The human readable name of this stop.
    ///
    /// ## Details
    /// - In WMATA GTFS data, this field is always written in all caps.
    /// - May not be suitable for display to users.
    /// - This field does not match the public name of the station.
    ///
    /// ## Example
    ///  `ASHBURN METRORAIL STATION`
    ///
    ///  ## Notes
    ///  While this field is only conditionally required by GTFS, WMATA includes it for all stops. Therefore, it's marked as non-null here.
    public var name: String
    
    /// A short description of the stop.
    ///
    /// ## Notes
    /// Not present on Metrorail stations.
    public var description: String?
    
    /// The latitude and longitude of this stop
    public var location: GTFSCoordinates
    
    /// Identifies the fare zone for a stop.
    ///
    /// ## Note
    /// I do not know what WMATA uses this field to represent.
    public var zoneID: String
    
    /// The GTFS `location_type` of a stop.
    public enum LocationType: Int, Hashable, Codable {
        /// A location where passengers board or disembark from a transit vehicle. Is called a platform when defined within a `parent_station`
        case platform = 0
        
        /// A physical structure or area that contains one or more platform.
        case station = 1
        
        /// A location where passengers can enter or exit a station from the street.
        case entrance = 2
        
        /// A location within a station, not matching any other `Location`, that may be used to link together pathways.
        ///
        /// ## Notes
        /// Unfortunately, WMATA uses this value for platforms instead of  ``platform``. Also used for elevator and escalator landings.
        case genericNode = 3
        
        /// A specific location on a platform, where passengers can board and/or alight vehicles.
        ///
        /// ## Notes
        /// Unused by WMATA.
        case boardingArea = 4
    }
    
    /// If this stop is a Platform, Station, Entrance, or some other type of location.
    public var locationType: LocationType
    
    /// If this stop is location within some other ``GTFSStop``
    public var parentStation: GTFSIdentifier<GTFSStop>?
    
    /// Indicates whether wheelchair boardings are possible from the location.
    public enum WheelchairBoarding: Int, Hashable, Codable {
        
        // Unused by WMATA.
        case noAccessibilityInformation = 0
        
        // Stop is wheelchair accessible
        case accessible = 1
        
        // Stop is not wheelchair accessible
        case notAccessible = 2
    }
    
    /// Indicates whether wheelchair boardings are possible from the location.
    public var wheelchairBoarding: WheelchairBoarding
    
    /// ``GTFSLevel`` of the location. The same level may be used by multiple unlinked stations.
    public var level: GTFSIdentifier<GTFSLevel>?
    
    /// Create a new Stop by providing all of it's fields
    public init(
        id: GTFSIdentifier<GTFSStop>,
        name: String,
        description: String? = nil,
        location: GTFSCoordinates,
        zoneID: String,
        locationType: LocationType,
        parentStation: GTFSIdentifier<GTFSStop>? = nil,
        wheelchairBoarding: WheelchairBoarding,
        level: GTFSIdentifier<GTFSLevel>? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.location = location
        self.zoneID = zoneID
        self.locationType = locationType
        self.parentStation = parentStation
        self.wheelchairBoarding = wheelchairBoarding
        self.level = level
    }
    
    /// Create all Stops with the given parent station
    ///
    /// - Parameters:
    ///   - id: The Stop ID of the Stop's parent Stop
    ///
    /// - Throws: `GTFSDatabaseError` if the GTFS database is unavailable or the database has some other issue
    /// - Throws: `GTFSDatabaseQueryError`, if the given stop ID is not in the database
    ///
    /// [More info about parent stations](https://gtfs.org/schedule/reference/#stopstxt)
    public static func all(withParentStation id: GTFSIdentifier<GTFSStop>) throws -> [GTFSStop] {
        let query = GTFSStop.table.filter(Expression<String?>("parent_station") == id.rawValue)
        
        return try GTFSStop.all(where: query)
    }
    
    /// Create all Stops with the given parent station
    ///
    /// See ``all(withParentStation:)-6rk0p``
    public static func all(withParentStation idString: @autoclosure @escaping () -> String) throws -> [GTFSStop] {
        return try self.all(withParentStation: .init(idString()))
    }
}

extension GTFSStop: SimpleQueryable {
    static let primaryKeyColumn = Expression<String>("stop_id")
    
    static let table = Table("stops")
    
    /// Create a Stop from a row in the GTFS database's stops table
    init(row: Row) throws {
        self.id = GTFSIdentifier(try row.get(Expression<String>("stop_id")))
        self.name = try row.get(Expression<String>("stop_name"))
        self.description = try row.get(Expression<String?>("stop_desc"))
        self.location = GTFSCoordinates(
            latitude: try row.get(Expression<Double>("stop_lat")),
            longitude: try row.get(Expression<Double>("stop_lon"))
        )
        self.zoneID = try row.get(Expression<String>("zone_id"))
        
        guard let locationType = LocationType(rawValue: try row.get(Expression<Int>("location_type"))) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSStop.self, key: "location_type")
        }
        
        self.locationType = locationType
        
        var parentStation: GTFSIdentifier<GTFSStop>? = nil
        
        if let parentStationID = try row.get(Expression<String?>("parent_station")) {
            parentStation = .init(parentStationID)
        }
        
        self.parentStation = parentStation
        
        
        guard let wheelchairBoarding = WheelchairBoarding(rawValue:  try row.get(Expression<Int>("wheelchair_boarding"))) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSStop.self, key: "wheelchair_boarding")
        }
        self.wheelchairBoarding = wheelchairBoarding
        
        var level: GTFSIdentifier<GTFSLevel>? = nil
        
        if let levelID = try row.get(Expression<String?>("level_id")) {
            level = .init(levelID)
        }
        
        self.level = level
    }
}
