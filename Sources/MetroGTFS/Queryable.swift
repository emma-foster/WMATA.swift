//
//  Queryable.swift
//
//
//  Created by Emma on 3/23/24.
//

import Foundation
import SQLite

protocol Queryable {
    /// The database table this structure is stored
    static var table: Table { get }
    
    /// Create this structure from a database row
    init(row: Row) throws
}

extension Queryable {
    /// Query the database for all structures of this type
    static func all(where query: Table = Self.table) throws -> [Self] {
        let database = try GTFSDatabase()
        
        return try database.run(query: query).map(Self.init)
    }
}

protocol SimpleQueryable: Queryable {
    /// A unique identifier for this structure that is also it's primary key in the database
    var id: GTFSIdentifier<Self> { get }
    
    /// The column within `Queryable.table` that the primary key is in
    static var primaryKeyColumn: Expression<String> { get }
}

extension SimpleQueryable {
    /// Query the database for this structure by it's unique ID
    init(id: GTFSIdentifier<Self>) throws {
        let database = try GTFSDatabase()
        
        let query = Self.table.filter(Self.primaryKeyColumn == id.rawValue)
        
        guard let row = try database.run(query: query) else {
            throw GTFSDatabaseQueryError<Self>.notFound(query: query, Self.table)
        }
        
        try self.init(row: row)
    }
    
    /// Query the database for this structure by it's unique ID string
    init(_ idString: @autoclosure @escaping () -> String) throws {
        try self.init(id: .init(idString()))
    }
}

protocol CompositeKeyQueryable: Queryable {
    static func createPrimaryKeyQuery<P1, P2>(_ primaryKey1: P1, _ primaryKey2: P2) -> Table where P1: Value, P1.Datatype: Equatable, P2: Value, P2.Datatype: Equatable
}

extension CompositeKeyQueryable {
    init<P1, P2>(_ primaryKey1: P1, _ primaryKey2: P2) throws where P1: Value, P1.Datatype: Equatable, P2: Value, P2.Datatype: Equatable {
        let database = try GTFSDatabase()
        
        let query = Self.createPrimaryKeyQuery(primaryKey1, primaryKey2)

        guard let row = try database.run(query: query) else {
            throw GTFSDatabaseQueryError<Self>.notFound(query: query, Self.table)
        }
        
        try self.init(row: row)
    }
}

protocol LongCompositeKeyQueryable: Queryable {
    static func createPrimaryKeyQuery<P1, P2>(_ primaryKey1: P1, _ primaryKey2: P1, _ primaryKey3: P1, _ primaryKey4: P1, _ primaryKey5: P2?, _ primaryKey6: P2?) -> Table where P1: Value, P1.Datatype: Equatable, P2: Value, P2.Datatype: Equatable
}

extension LongCompositeKeyQueryable {
    init<P1, P2>(_ primaryKey1: P1, _ primaryKey2: P1, _ primaryKey3: P1, _ primaryKey4: P1, _ primaryKey5: P2?, _ primaryKey6: P2?) throws where P1: Value, P1.Datatype: Equatable, P2: Value, P2.Datatype: Equatable {
        let database = try GTFSDatabase()
        
        let query = Self.createPrimaryKeyQuery(primaryKey1, primaryKey2, primaryKey3, primaryKey4, primaryKey5, primaryKey6)

        guard let row = try database.run(query: query) else {
            throw GTFSDatabaseQueryError<Self>.notFound(query: query, Self.table)
        }
        
        try self.init(row: row)
    }
}
