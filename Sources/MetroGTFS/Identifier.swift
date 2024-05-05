//
//  WMATAIdentifier.swift
//
//
//  Created by Emma on 11/25/23.
//

import Foundation
import SQLite

/// A generic identifier. Used to associate a specific type with some structure used within the MetroGTFS
///
///  This type encodes to a single value in JSON.
///
///  This type uses a Phantom Generic to differentate IDs of different data types.
public struct GTFSIdentifier<Structure>: Equatable, Hashable, RawRepresentable {
    /// The identifier for the current `Structure`.
    public var rawValue: String
    
    /// Create a new Identifier with the given id.
    public init(_ id: String) {
        self.rawValue = id
    }
    
    public init(rawValue id: String) {
        self.rawValue = id
    }
    
    public init?(rawValue id: String?) {
        if let id {
            self.rawValue = id
        }
        
        return nil
    }
}

extension GTFSIdentifier: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try container.decode(String.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

extension GTFSIdentifier: Value {
    public static func fromDatatypeValue(_ datatypeValue: String) -> GTFSIdentifier<Structure> {
        self.init(rawValue: datatypeValue)
    }
    
    public var datatypeValue: String {
        self.rawValue
    }
    
    public typealias Datatype = String
    
    public static var declaredDatatype: String {
        String.declaredDatatype
    }
}
