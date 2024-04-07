//
//  Pathway.swift
//
//
//  Created by Emma on 4/6/24.
//

import Foundation
import SQLite

/// A path between two ``GTFSStop``s.
///
/// [See pathways.txt docs](https://gtfs.org/schedule/reference/#pathwaystxt)
///
/// ```
/// let pathway = try GTFSPathway("C05_134128")
///
/// pathway.length // .init(value: 159.8745823, unit: .meters)
/// pathway.transversalTime // .init(value: 35.0, unit: .seconds)
/// pathway.mode // .walkway
/// ```
public struct GTFSPathway: Equatable, Hashable, Codable {
    
    /// A unique identifier for this pathway
    public var id: GTFSIdentifier<GTFSPathway>
    
    /// Location where this pathway begins
    public var fromStopID: GTFSIdentifier<GTFSStop>
    
    /// Location where this pathway ends
    public var toStopID: GTFSIdentifier<GTFSStop>
    
    /// The type of a pathway
    public enum Mode: Int, Equatable, Hashable, Codable {
        /// Walkway or hallway
        case walkway = 1
        
        /// Stairs, up or down
        case stairs
        
        /// Moving sidewalk/travelator
        case movingSidewalk
        
        /// Alias for ``movingSidewalk``
        static let travelator = Mode.movingSidewalk
        
        /// An escalator
        case escalator
        
        /// An elevator
        case elevator
        
        /// A pathway that crosses into an area of the station where proof of payment is required to cross. Fare gates may separate paid areas of the station from unpaid ones, or separate different payment areas within the same station from each other. This information can be used to avoid routing passengers through stations using shortcuts that would require passengers to make unnecessary payments, like directing a passenger to walk through a subway platform to reach a busway.
        case fareGate
        
        /// Alias for ``fareGate``
        static let paymentGate = Mode.fareGate
        
        /// A pathway exiting a paid area into an unpaid area where proof of payment is not required to cross.
        case exitGate
    }
    
    /// The type of this pathway
    public var mode: Mode
    
    /// The direction that the pathway can be taken.
    public enum Bidirectional: Int, Equatable, Hashable, Codable {
        /// Unidirectional pathway that can only be used from `fromStopID` to `toStopID`.
        case unidirectional = 0
        
        /// Bidirectional pathway that can be used in both directions.
        ///
        /// ``Mode/exitGate`` are always ``bidirectional``.
        case bidirectional
    }
    
    /// The direction this pathway can be taken
    public var isBidirectional: Bidirectional
    
    /// Horizontal length in meters of the pathway from the origin location (defined in ``fromStopID``) to the destination location (defined in ``toStopID``)
    public var length: Measurement<UnitLength>
    
    /// Average time in seconds needed to walk through the pathway from the origin location (defined in ``fromStopID``) to the destination location (defined in ``toStopID``).
    public var transversalTime: Measurement<UnitDuration>
    
    /// Number of stairs along the pathway.
    ///
    /// A positive `stairCount` implies that the rider walk up from ``fromStopID`` to ``toStopID``. And a negative `stairCount` implies that the rider walk down from `fromStopID` to `toStopID`.
    public var stairCount: Int?
    
    /// Maximum slope ratio of the pathway
    ///
    /// - `0` indicates no slope
    /// -  positive for upwards
    /// - negative for downwards
    ///
    /// WMATA does not use this field. Metro is accessible.
    public var maxSlope: Double?
    
    /// Minimum width of the pathway in meters
    public var minimumWidth: Measurement<UnitLength>?
    
    /// Public facing text from physical signage that is visible to riders
    ///
    /// May be used to provide text directions to riders, such as 'follow signs to '
    public var signpostedAs: String?
    
    /// Create a new pathway by providing all of it's properties
    public init(id: GTFSIdentifier<GTFSPathway>, fromStopID: GTFSIdentifier<GTFSStop>, toStopID: GTFSIdentifier<GTFSStop>, mode: Mode, isBidirectional: Bidirectional, length: Measurement<UnitLength>, transversalTime: Measurement<UnitDuration>, stairCount: Int? = nil, maxSlope: Double? = nil, minimumWidth: Measurement<UnitLength>? = nil, signpostedAs: String? = nil) {
        self.id = id
        self.fromStopID = fromStopID
        self.toStopID = toStopID
        self.mode = mode
        self.isBidirectional = isBidirectional
        self.length = length
        self.transversalTime = transversalTime
        self.stairCount = stairCount
        self.maxSlope = maxSlope
        self.minimumWidth = minimumWidth
        self.signpostedAs = signpostedAs
    }
}

extension GTFSPathway: GTFSStructure {
    enum TableColumn {
        static let id = Expression<String>("pathway_id")
        static let fromStopID = Expression<String>("from_stop_id")
        static let toStopID = Expression<String>("to_stop_id")
        static let mode = Expression<Int>("pathway_mode")
        static let isBidirectional = Expression<Int>("is_bidirectional")
        static let length = Expression<Double>("length")
        static let transversalTime = Expression<Int>("traversal_time")
        static let stairCount = Expression<Int?>("stair_count")
        static let maxSlope = Expression<Double?>("max_slope")
        static let minimumWidth = Expression<Double?>("min_width")
        static let signpostedAs = Expression<String?>("signposted_as")
    }
    
    static let databaseTable = GTFSDatabase.Table(
        sqlTable: SQLite.Table("pathways"),
        primaryKeyColumn: TableColumn.id
    )
    
    init(row: Row) throws {
        self.id = .init(try row.get(TableColumn.id))
        self.fromStopID = .init(try row.get(TableColumn.fromStopID))
        self.toStopID = .init(try row.get(TableColumn.toStopID))
        
        guard let mode = Mode(rawValue: try row.get(TableColumn.mode)) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSPathway.self, key: "pathway_mode")
        }
        
        self.mode = mode
        
        guard let isBidirectional = Bidirectional(rawValue: try row.get(TableColumn.isBidirectional)) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSPathway.self, key: "is_bidirectional")
        }
        
        self.isBidirectional = isBidirectional
        self.length = Measurement(value: try row.get(TableColumn.length), unit: .meters)
        self.transversalTime = Measurement(value: Double(try row.get(TableColumn.transversalTime)), unit: .seconds)
        
        if let stairCount = try row.get(TableColumn.stairCount) {
            self.stairCount = stairCount
        }
        
        if let maxSlope = try row.get(TableColumn.maxSlope) {
            self.maxSlope = maxSlope
        }
        
        if let minimumWidth = try row.get(TableColumn.minimumWidth) {
            self.minimumWidth = Measurement(value: minimumWidth, unit: .meters)
        }
        
        if let signpostedAs = try row.get(TableColumn.signpostedAs) {
            self.signpostedAs = signpostedAs
        }
    }
}
