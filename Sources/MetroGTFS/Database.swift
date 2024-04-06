//
//  Database.swift
//
//
//  Created by Emma on 11/26/23.
//

import Foundation
import SQLite

/// The GTFS Static Database. Used to perform queries on the GTFS Static Database.
struct GTFSDatabase {
    private let connection: Connection
    
    /// Create a new GTFS Database. If there is not currently an open connection to the database, create one.
    init() throws {
        if let connection = GTFSDatabase.shared {
            self.connection = connection
            
            return
        }
        
        let connection: Connection
        
        do {
            connection = try GTFSDatabase.connection()
        } catch {
            throw GTFSDatabaseError.unableToConnectToDatabase
        }
        
        GTFSDatabase.shared = connection
        
        self.connection = connection
    }
    
    /// Run a database query that only returns one row
    func run(query: SQLite.Table) throws -> Row? {
        do {
            return try connection.pluck(query)
        } catch {
            throw GTFSDatabaseError.unableToPerformQuery(query)
        }
    }
    
    /// Run a database query that returns multiple rows
    func run(query: SQLite.Table) throws -> AnySequence<Row> {
        do {
            return try connection.prepare(query)
        } catch {
            throw GTFSDatabaseError.unableToPerformQuery(query)
        }
    }
}

extension GTFSDatabase {
    /// Get all GTFS Structures of the given type from the GTFS Database
    func all<Structure: GTFSStructure>(_ structure: Structure.Type) throws -> AnySequence<Row> {
        return try run(query: structure.databaseTable.sqlTable)
    }
    
    /// Get all GTFS Structures of the given type with the given `id` in the given `column`. Defaults to using the primary key column.
    func all<Structure: GTFSStructure>(
        _ structure: Structure.Type,
        with id: GTFSIdentifier<Structure>,
        in column: SQLite.Expression<String> = Structure.databaseTable.primaryKeyColumn
    ) throws -> AnySequence<Row> {
        return try run(query: structure.databaseTable.sqlTable.where(column == id.rawValue))
    }
    
    /// Get all GTFS Structures of the given type with the given `id` in the given `column`.
    func all<Structure: GTFSStructure>(
        _ structure: Structure.Type,
        with id: GTFSIdentifier<Structure>,
        in column: SQLite.Expression<String?>
    ) throws -> AnySequence<Row> {
        return try run(query: structure.databaseTable.sqlTable.where(column == id.rawValue))
    }
    
    /// Get all GTFS Structures of the given type that match the given query
    func all<Structure: GTFSStructure>(
        _ structure: Structure.Type,
        where query: SQLite.Table
    ) throws -> AnySequence<Row> {
        return try self.run(query: query)
    }
    
    /// Get a single structure of the given type with the given `id` in the given `column`. Defaults to using the primary key column.
    func one<Structure: GTFSStructure>(
        _ structure: Structure.Type,
        with id: GTFSIdentifier<Structure>,
        in column: SQLite.Expression<String> = Structure.databaseTable.primaryKeyColumn
    ) throws -> Row? {
        try run(query: structure.databaseTable.sqlTable.where(column == id.rawValue))
    }

    /// Get a single GTFS structure of the given type that matches the given query.
    func one<Structure: GTFSStructure>(
        _ structure: Structure.Type,
        where query: SQLite.Table
    ) throws ->Row? {
        return try self.run(query: query)
    }
}

extension GTFSDatabase {
    /// The global shares connection to the GTFS database
    private static var shared: Connection?
    
    /// Create a new connection to the MetroGTFS SQLite database
    private static func connection() throws -> Connection  {
        let path = Bundle.module.path(forResource: "MetroGTFS", ofType: "sqlite3")
        
        guard let path else {
            throw GTFSDatabaseError.failedToLoadDatabase
        }
        
        let connection = try Connection(path, readonly: true)
        
        return connection
    }
}

extension GTFSDatabase {
    /// A SQLite database table and the column it's primary key is in
    struct Table {
        let sqlTable: SQLite.Table
        let primaryKeyColumn: SQLite.Expression<String>
    }
}
