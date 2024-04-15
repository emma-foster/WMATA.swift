//
//  FareLegRules.swift
//
//
//  Created by Emma on 4/3/24.
//

import Foundation
import SQLite

/// Fare rules for individual legs of travel.
///
/// [Full GTFS docs](https://gtfs.org/schedule/reference/#fare_leg_rulestxt)
///
/// ## Example
/// ```
/// let fareLegRule = try GTFSFareLegRule(
///   fromAreaID: "STN_A02",
///   toFromArea: "STN_J03",
///   fromService: "weekday_regular"
/// )
///
/// fareLegRule.fareProduct // .init("600_regular")
/// ```
public struct GTFSFareLegRule: Equatable, Hashable, Codable {
    /// The route network this fare leg rule applies to
    ///
    /// For WMATA, this is always `Metrorail`
    public var networkID: GTFSIdentifier<GTFSNetwork>
    
    /// The area this leg starts
    public var fromAreaID: GTFSIdentifier<GTFSArea>
    
    /// The area this leg ends
    public var toAreaID: GTFSIdentifier<GTFSArea>
    
    /// The fare required to travel on this leg
    public var fareProduct: GTFSIdentifier<GTFSFareProduct>
    
    /// The timeframe this fare is valid, assuming the fare validation occurs at the start of the leg
    public var fromService: GTFSIdentifier<GTFSService>?
    
    /// The timeframe this fare is valid, assuming the fare validation occurrs at the end of the leg
    public var toService: GTFSIdentifier<GTFSService>?
    
    /// Create a Fare Leg Rule by providing all of it's fields.
    public init(
        networkID: GTFSIdentifier<GTFSNetwork>,
        fromAreaID: GTFSIdentifier<GTFSArea>,
        toAreaID: GTFSIdentifier<GTFSArea>,
        fareProduct: GTFSIdentifier<GTFSFareProduct>,
        fromService: GTFSIdentifier<GTFSService>? = nil,
        toService: GTFSIdentifier<GTFSService>? = nil
    ) {
        self.networkID = networkID
        self.fromAreaID = fromAreaID
        self.toAreaID = toAreaID
        self.fareProduct = fareProduct
        self.fromService = fromService
        self.toService = toService
    }
    
    /// Query the database for a fare leg rule.
    ///
    /// All fields are required to receive a unique fare leg rule.
    ///
    /// For WMATA, `networkID` is always `MetroRail` and `toService` is unused.
    ///
    /// ## Example
    /// ```
    /// let fareLegRule = try GTFSFareLegRule(
    ///     networkID: .init("Metrorail"),
    ///     fromAreaID: .init("A03"),
    ///     toAreaID: .init("J02"),
    ///     fromService: .init("weekday_regular")
    /// )
    /// ```
    public init(
        networkID: GTFSIdentifier<GTFSNetwork>? = nil,
        fromAreaID: GTFSIdentifier<GTFSArea>? = nil,
        toAreaID: GTFSIdentifier<GTFSArea>? = nil,
        fareProduct: GTFSIdentifier<GTFSFareProduct>? = nil,
        fromService: GTFSIdentifier<GTFSService>? = nil,
        toService: GTFSIdentifier<GTFSService>? = nil
    ) throws {
        var query = GTFSFareLegRule.databaseTable.sqlTable
        
        if let networkID {
            query = query.filter(TableColumn.networkID == networkID.rawValue)
        }
        
        if let fromAreaID {
            query = query.filter(TableColumn.fromAreaID == fromAreaID.rawValue)
        }
        
        if let toAreaID {
            query = query.filter(TableColumn.toAreaID == toAreaID.rawValue)
        }
        
        if let fareProduct {
            query = query.filter(TableColumn.fareProduct == fareProduct.rawValue)
        }
        
        if let fromService {
            query = query.filter(TableColumn.fromService == fromService.rawValue)
        }
        
        if let toService {
            query = query.filter(TableColumn.toService == toService.rawValue)
        }
        
        try self.init(where: query)
    }
    
    /// Query the database for a fare leg rule.
    ///
    /// All fields are required to receive a unique fare leg rule.
    ///
    /// For WMATA, `networkID` is always `MetroRail` and `toService` is unused.
    public init(
        networkID: @autoclosure @escaping () -> String? = nil,
        fromAreaID: @autoclosure @escaping () -> String? = nil,
        toAreaID: @autoclosure @escaping () -> String? = nil,
        fareProduct: @autoclosure @escaping () -> String? = nil,
        fromService:@autoclosure @escaping () -> String? = nil,
        toService: @autoclosure @escaping () -> String? = nil
    ) throws {
        var query = GTFSFareLegRule.databaseTable.sqlTable
        
        if let networkID = networkID() {
            query = query.filter(TableColumn.networkID == networkID)
        }
        
        if let fromAreaID = fromAreaID() {
            query = query.filter(TableColumn.fromAreaID == fromAreaID)
        }
        
        if let toAreaID = toAreaID() {
            query = query.filter(TableColumn.toAreaID == toAreaID)
        }
        
        if let fareProduct = fareProduct() {
            query = query.filter(TableColumn.fareProduct == fareProduct)
        }
        
        if let fromService = fromService() {
            query = query.filter(TableColumn.fromService == fromService)
        }
        
        if let toService = toService() {
            query = query.filter(TableColumn.toService == toService)
        }
        
        try self.init(where: query)
    }
}

extension GTFSFareLegRule: GTFSStructure {
    var id: GTFSIdentifier<GTFSFareLegRule> {
        .init([
            networkID.rawValue,
            fromAreaID.rawValue,
            toAreaID.rawValue,
            fromService?.rawValue,
            toService?.rawValue,
            fareProduct.rawValue
        ].compactMap { $0 }.joined())
    }
    
    enum TableColumn {
        static let networkID = Expression<String>("network_id")
        static let fromAreaID = Expression<String>("from_area_id")
        static let toAreaID = Expression<String>("to_area_id")
        static let fareProduct = Expression<String>("fare_product_id")
        static let fromService = Expression<String?>("from_timeframe_group_id")
        static let toService = Expression<String?>("to_timeframe_group_id")
    }
    
    static let databaseTable = GTFSDatabase.Table(
        sqlTable: SQLite.Table("fare_leg_rules"),
        primaryKeyColumn: TableColumn.networkID
    )
    
    init(row: Row) throws {
        self.networkID = .init(try row.get(TableColumn.networkID))
        self.fromAreaID = .init(try row.get(TableColumn.fromAreaID))
        self.toAreaID = .init(try row.get(TableColumn.toAreaID))
        self.fareProduct = .init(try row.get(TableColumn.fareProduct))
        let fromService = try row.get(TableColumn.fromService)
        
        if let fromService {
            self.fromService = .init(fromService)
        }
        
        let toService = try row.get(TableColumn.toService)
        
        if let toService {
            self.toService = .init(toService)
        }
    }
}
