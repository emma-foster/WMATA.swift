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
