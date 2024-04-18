//
//  GTFSStructure.swift
//  
//
//  Created by Emma on 3/23/24.
//

import Foundation
import SQLite

/// Create an GTFS Structures from a database table
protocol GTFSStructure {
    /// The columns in the table of GTFS Static database for this structure type
    associatedtype TableColumn
    
    /// The actual table in SQLite to pull the data type from
    static var databaseTable: GTFSDatabase.Table { get }
    
    /// Create this structure from a database row
    init(row: Row) throws
    
    /// A unique identifier for this structure. Usually the primary key in the database.
    var id: GTFSIdentifier<Self> { get }
}

extension GTFSStructure {
    /// Create a GTFS structure from an ID. Performs a database query.
    ///
    /// - Parameters:
    ///   - idString: A unique identifier for the structure.
    ///
    ///   - Throws: ``GTFSDatabaseError`` if the GTFS database is unavailable or the database has some other issue
    ///   - Throws: ``GTFSDatabaseQueryError`` if the given ID does not exist in the database
    ///
    /// ```swift
    /// let agency = try GTFSAgency(id: .init("MET"))
    ///
    /// agency.name // "WMATA"
    /// ```
    public init(id: GTFSIdentifier<Self>) throws {
        let database = try GTFSDatabase()
        
        let row = try database.one(Self.self, with: id)
        
        guard let row else {
            throw GTFSDatabaseQueryError.notFound(id, Self.databaseTable.sqlTable)
        }
        
        try self.init(row: row)
    }
    
    /// Create this structure from many SQLite expressions. Useful when tables have composite primary keys.
    init(where query: SQLite.Table) throws {
        let database = try GTFSDatabase()
        
        let row = try database.one(Self.self, where: query)
        
        guard let row else {
            throw GTFSDatabaseQueryError<Self>.notFound(query: query, Self.databaseTable.sqlTable)
        }
        
        try self.init(row: row)
    }
    
    /// Create a GTFS structure from an ID string. Performs a database query.
    ///
    /// - Parameters:
    ///   - idString: A unique identifier for the structure.
    ///
    ///   - Throws: ``GTFSDatabaseError`` if the GTFS database is unavailable or the database has some other issue
    ///   - Throws: ``GTFSDatabaseQueryError`` if the given Agency ID does not exist in the database
    ///
    /// ```swift
    /// let agency = try GTFSLevel("MET")
    ///
    /// agency.name // "WMATA"
    /// ```
    public init(_ idString: @autoclosure @escaping () -> String) throws {
        try self.init(id: .init(idString()))
    }
    
    /// Create every GTFS structure of this type present in the database. Performs a database query.
    // TODO: should this really be public?
    
    public static func all(with id: GTFSIdentifier<Self>? = nil, in expression: Expression<String>? = nil) throws -> [Self] {
        let database = try GTFSDatabase()
        
        let allRows: AnySequence<Row>
        
        if let id, let expression {
            allRows = try database.all(Self.self, with: id, in: expression)
        } else if let id {
            allRows = try database.all(Self.self, with: id)
        } else {
            allRows = try database.all(Self.self)
        }
        
        return try allRows.map { try .init(row: $0) }
    }
    
    /// Query the database for all structures of this type with that match the given query
    static func all(where query: Table) throws -> [Self] {
        let database = try GTFSDatabase()
        
        let rows = try database.all(Self.self, where: query)
        
        return try rows.map { try self.init(row: $0) }
    }
}

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
