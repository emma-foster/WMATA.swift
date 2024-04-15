//
//  Agency.swift
//
//
//  Created by Emma on 3/23/24.
//

import Foundation
import SQLite

/// A [GTFS Agency](https://gtfs.org/schedule/reference/#agencytxt). Describes the different physical levels and floors in a station. Can be used with pathways to navigate stations.
///
/// ```swift
/// let level = try GTFSAgency("1")
///
/// level.name // "WMATA"
/// ```
public struct GTFSAgency: Equatable, Hashable, Codable {
    /// A unique identifier for this agency. `1` for WMATA.
    public var id: GTFSIdentifier<GTFSAgency>
    
    /// The user-friendly name of the agency. `WMATA` for WMATA.
    public var name: String
    
    /// The URL of the agency's public website. `https://wmata.com` for WMATA.
    public var url: URL
    
    /// The time zone ID the agency operates in. `America/New_York` for WMATA.
    public var timeZone: TimeZone
    
    /// The language ID the agency primarily operates in. `en` for WMATA.
    public var language: String
    
    /// The phone number of the agency. `202-637-7000` for WMATA.
    public var phone: String
    
    /// The URL of the agency's public website where fare information is available. `https://www.wmata.com/fares/` for WMATA.
    public var fareURL: URL
    
    /// Create a new GTFS Agency by providing all of it's fields
    public init(id: GTFSIdentifier<GTFSAgency>, name: String, url: URL, timeZone: TimeZone, language: String, phone: String, fareURL: URL) {
        self.id = id
        self.name = name
        self.url = url
        self.timeZone = timeZone
        self.language = language
        self.phone = phone
        self.fareURL = fareURL
    }
}

extension GTFSAgency: SimpleQueryable {
    static let table = SQLite.Table("agency")
    
    static let primaryKeyColumn = Expression<String>("agency_id")
    
    /// Create an Agency from a database row in the `agency` table
    init(row: Row) throws {
        self.id = GTFSIdentifier(try row.get(Expression<String>("agency_id")))
        
        self.name = try row.get(Expression<String>("agency_name"))
        self.url = try row.get(Expression<URL>("agency_url"))
        
        guard let timeZone = TimeZone(identifier: try row.get(Expression<String>("agency_timezone"))) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSAgency.self, key: "timeZone")
        }
        
        self.timeZone = timeZone
        self.language = try row.get(Expression<String>("agency_lang"))
        self.phone = try row.get(Expression<String>("agency_phone"))
        self.fareURL = try row.get(Expression<URL>("agency_fare_url"))
    }
}
