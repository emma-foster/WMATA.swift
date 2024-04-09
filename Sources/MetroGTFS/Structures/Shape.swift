//
//  Shape.swift
//
//
//  Created by Emma on 4/6/24.
//

import Foundation
import SQLite

/// The path a vehicle travels along a route.
///
/// Each `GTFSShape` represents a single point along
///
/// ## Examples
/// ```
/// // A single shape point
/// let shapePoint = try GTFSShape("RRED_1", pointSequence: 3)
///
/// shapePoint.latitude.value // 39.119990
/// shapePoint.longitude.unit // .degrees
/// ```
///
/// ```
/// // Entire shape
/// let shape = try GTFSShape.entireShape("RRED_1")
///
/// shape.last?.distanceTraveled.value // 32.3763
/// ```
public struct GTFSShape: Equatable, Hashable, Codable {
    /// A unique identifier for this shape
    public var id: GTFSIdentifier<GTFSShape>
    
    /// Latitude of a shape point
    public var latitude: Measurement<UnitAngle>
    
    /// Longitude of a shape point
    public var longitude: Measurement<UnitAngle>
    
    /// Sequence in which the shape points connect to form the shape. Values must increase along the trip but do not need to be consecutive.
    public var pointSequence: Int
    
    /// Actual distance traveled along the shape from the first shape point to the point specified in this shape point.
    ///
    /// For WMATA, the distance unit used is miles.
    public var distanceTraveled: Measurement<UnitLength>
    
    /// Create a new shape by providing all of it's fields
    public init(id: GTFSIdentifier<GTFSShape>, latitude: Measurement<UnitAngle>, longitude: Measurement<UnitAngle>, pointSequence: Int, distanceTraveled: Measurement<UnitLength>) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.pointSequence = pointSequence
        self.distanceTraveled = distanceTraveled
    }
    
    /// Query the database for a specific shape
    public init(id: GTFSIdentifier<GTFSShape>, pointSequence: Int) throws {
        try self.init(where: GTFSShape.databaseTable.sqlTable
            .filter(TableColumn.id == id.rawValue)
            .filter(TableColumn.pointSequence == pointSequence)
        )
    }
    
    /// Query the database for a specific shape
    public init(_ id: @autoclosure @escaping () -> String, pointSequence: Int) throws {
        try self.init(id: .init(id()), pointSequence: pointSequence)
    }
    
    /// Get all `GTFSShape` points within the given shape.
    public static func entireShape(id: GTFSIdentifier<GTFSShape>) throws -> [GTFSShape] {
        try self.all(where: GTFSShape.databaseTable.sqlTable.filter(TableColumn.id == id.rawValue))
    }
    
    /// Get all `GTFSShape` points within the given shape.
    public static func entireShape(_ id: @autoclosure @escaping () -> String) throws -> [GTFSShape] {
        try entireShape(id: .init(id()))
    }
}

extension GTFSShape: GTFSStructure {
    enum TableColumn {
        static let id = Expression<String>("shape_id")
        static let latitude = Expression<Double>("shape_pt_lat")
        static let longitude = Expression<Double>("shape_pt_lon")
        static let pointSequence = Expression<Int>("shape_pt_sequence")
        static let distanceTraveled = Expression<Double>("shape_dist_traveled")
    }
    
    static let databaseTable = GTFSDatabase.Table(
        sqlTable: SQLite.Table("shapes"),
        primaryKeyColumn: TableColumn.id
    )
    
    init(row: Row) throws {
        self.id = .init(try row.get(TableColumn.id))
        self.latitude = Measurement(value: try row.get(TableColumn.latitude), unit: .degrees)
        self.longitude = Measurement(value: try row.get(TableColumn.longitude), unit: .degrees)
        self.pointSequence = try row.get(TableColumn.pointSequence)
        self.distanceTraveled = Measurement(value: try row.get(TableColumn.distanceTraveled), unit: .miles)
    }
}
