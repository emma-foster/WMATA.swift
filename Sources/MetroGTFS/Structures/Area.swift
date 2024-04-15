//
//  Area.swift
//
//
//  Created by Emma on 3/29/24.
//

import Foundation
import SQLite

/// A [GTFS Area](https://gtfs.org/schedule/reference/#areastxt). Defines IDs for areas within the transit system. For WMATA, these represent physical stations or `everywhere`.
///
/// ## Example
/// ```
/// let area = try GTFSArea("STN_A01_C01") // Metro Center
/// ```
public struct GTFSArea: Equatable, Hashable, Codable {
    
    /// A unique ID for the area. For WMATA, this is a Station Code (or multiple for transfer stations) prefixed by `STN_`.
    ///
    /// ## Example
    ///
    /// `STN_A02` // Farragut North
    /// `STN_B01_F01` // Gallery Place
    public var id: GTFSIdentifier<GTFSArea>
    
    /// Create a new area by providing all of it's properties
    public init(id: GTFSIdentifier<GTFSArea>) {
        self.id = id
    }
}

extension GTFSArea: SimpleQueryable {
    static let primaryKeyColumn = Expression<String>("area_id")
    
    static let table = Table("areas")
    
    init(row: Row) throws {
        self.id = .init(try row.get(Expression<String>("area_id")))
    }
}
