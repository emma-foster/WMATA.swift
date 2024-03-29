//
//  Error.swift
//
//
//  Created by Emma on 11/26/23.
//

import Foundation
import SQLite

/// Errors associated with creating or loading the SQLite database
public enum GTFSDatabaseError: Error {
    /// Unable to find or load the SQLite databse file
    case failedToLoadDatabase
    
    /// Unable to create a new connected to an already created SQLite database
    case unableToConnectToDatabase
    
    /// Unable to run the given query against a SQLite database table
    ///
    /// Note that in the SQLite wrapper MetroGTFS uses, a Table is the data type used to represent a query.
    case unableToPerformQuery(Table)
    
    /// The given rows does is not valid and could not be loaded. Usually associated with some ``GTFSDatabaseDecodingError``.
    case invalid(Row)
}

/// Errors associated with incorrect SQLite database queries
public enum GTFSDatabaseQueryError<Structure>: Error {
    /// The requested row does not exist in the given SQLite database table
    case notFound(GTFSIdentifier<Structure>, Table)
    
    /// No rows match the given predicate in the SQLite database table
    case notFound(predicate: Expression<Bool>, Table)
}

/// Errors associated with decoding SQLite table rows into Swift types
public enum GTFSDatabaseDecodingError<Structure>: Error {
    /// Occurs when a row in the SQLite database does not have
    case invalidEntry(structureType: Structure.Type, key: String)
}
