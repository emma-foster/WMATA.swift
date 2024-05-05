//
//  Network.swift
//
//
//  Created by Emma on 3/24/24.
//

import Foundation
import SQLite

/// A [GTFS Network](https://gtfs.org/schedule/reference/#networkstxt)
///
/// Used to determine which network a ``GTFSRoute`` belongs to.
///
/// Transferring between networks an incur a fare, described in `fare_leg_rules.txt`.
///
/// - Warning: The `networks` table does not currently exist in the GTFS Database, so you cannot create a ``GTFSNetwork`` from the database.
///
/// ```
/// let network = try GTFSNetwork(id: .init("Metrorail"))
/// ```
public struct GTFSNetwork: Equatable, Hashable, Codable {
    /// A unique identifier for this network
    public var id: GTFSIdentifier<GTFSNetwork>
    
    /// The name of this network. Used in `fare_leg_rules.txt` and ``GTFSRoute``
    public var name: String?
    
    /// Create a new network by providing all of it's fields
    init(id: GTFSIdentifier<GTFSNetwork>, name: String? = nil) {
        self.id = id
        self.name = name
    }
}

// TODO: 
extension GTFSNetwork: SimpleQueryable {
    static let primaryKeyColumn = Expression<String>("network_id")
    
    static let table = Table("network")
    
    init(row: Row) throws {
        self.id = .init(try row.get(Expression<String>("network_id")))
        self.name = try row.get(Expression<String>("network_name"))
    }
}
