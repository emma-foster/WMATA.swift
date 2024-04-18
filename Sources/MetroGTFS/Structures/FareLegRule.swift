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
///     networkID: "Metrorail",
///     fromAreaID: "STN_A01_C01",
///     toAreaID: "STN_A03",
///     fareProductID: "200_regular",
///     fromServiceID: "weekday_regular"
/// )
///
/// fareLegRule.fareProductID // .init("600_regular")
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
    public var fareProductID: GTFSIdentifier<GTFSFareProduct>
    
    /// The timeframe this fare is valid, assuming the fare validation occurs at the start of the leg
    public var fromServiceID: GTFSIdentifier<GTFSService>?
    
    /// The timeframe this fare is valid, assuming the fare validation occurrs at the end of the leg
    public var toServiceID: GTFSIdentifier<GTFSService>?
    
    /// Create a Fare Leg Rule by providing all of it's fields.
//    public init(
//        networkID: GTFSIdentifier<GTFSNetwork>,
//        fromAreaID: GTFSIdentifier<GTFSArea>,
//        toAreaID: GTFSIdentifier<GTFSArea>,
//        fareProduct: GTFSIdentifier<GTFSFareProduct>,
//        fromService: GTFSIdentifier<GTFSService>? = nil,
//        toService: GTFSIdentifier<GTFSService>? = nil
//    ) {
//        self.networkID = networkID
//        self.fromAreaID = fromAreaID
//        self.toAreaID = toAreaID
//        self.fareProduct = fareProduct
//        self.fromService = fromService
//        self.toService = toService
//    }
    
    /// Query the database for a fare leg rule.
    ///
    /// All fields are required to receive a unique fare leg rule.
    ///
    /// For WMATA, `networkID` is always `MetroRail` and `toService` is unused.
    ///
    /// ## Example
    /// ```
    /// let fareLegRule = try GTFSFareLegRule(
    ///   networkID: .init("Metrorail"),
    ///   fromAreaID: .init("everywhere"),
    ///   toAreaID: .init("everywhere"),
    ///   fareProductID: .init("200_flat"),
    ///   fromServiceID: .init("weekday_flat")
    /// )
    /// ```
    public init(
        networkID: GTFSIdentifier<GTFSNetwork>,
        fromAreaID: GTFSIdentifier<GTFSArea>,
        toAreaID: GTFSIdentifier<GTFSArea>,
        fareProductID: GTFSIdentifier<GTFSFareProduct>,
        fromServiceID: GTFSIdentifier<GTFSService>? = nil,
        toServiceID: GTFSIdentifier<GTFSService>? = nil
    ) throws {
        try self.init(
            networkID.rawValue,
            fromAreaID.rawValue,
            toAreaID.rawValue,
            fareProductID.rawValue,
            fromServiceID?.rawValue,
            toServiceID?.rawValue
        )
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
    ///     networkID: "Metrorail",
    ///     fromAreaID: "STN_A01_C01",
    ///     toAreaID: "STN_A03",
    ///     fareProductID: "200_regular",
    ///     fromServiceID: "weekday_regular"
    /// )
    /// ```
    public init(
        networkID: @autoclosure @escaping () -> String,
        fromAreaID: @autoclosure @escaping () -> String,
        toAreaID: @autoclosure @escaping () -> String,
        fareProductID: @autoclosure @escaping () -> String,
        fromServiceID: @autoclosure @escaping () -> String? = { nil }(),
        toServiceID: @autoclosure @escaping () -> String? = { nil }()
    ) throws {
        try self.init(
            networkID(),
            fromAreaID(),
            toAreaID(),
            fareProductID(),
            fromServiceID(),
            toServiceID()
        )
    }
}

extension GTFSFareLegRule: LongCompositeKeyQueryable {
    static func createPrimaryKeyQuery<P1, P2>(_ primaryKey1: P1, _ primaryKey2: P1, _ primaryKey3: P1, _ primaryKey4: P1, _ primaryKey5: P2?, _ primaryKey6: P2?) -> SQLite.Table where P1 : SQLite.Value, P2 : SQLite.Value, P1.Datatype : Equatable, P2.Datatype : Equatable {
        var query = Expression<P1>("network_id") == primaryKey1
        query = query && Expression<P1>("from_area_id") == primaryKey2
        query = query && Expression<P1>("to_area_id") == primaryKey3
        query = query && Expression<P1>("fare_product_id") == primaryKey4
        if let primaryKey5 {
            query = query && Expression<P2>("from_timeframe_group_id") == primaryKey5
        }
        
        if let primaryKey6 {
            query = query && Expression<P2>("to_timeframe_group_id") == primaryKey6
        }
        return table.filter(query)
    }
    
    static let table = Table("fare_leg_rules")
    
    init(row: Row) throws {
        self.networkID = .init(try row.get(Expression<String>("network_id")))
        self.fromAreaID = .init(try row.get(Expression<String>("from_area_id")))
        self.toAreaID = .init(try row.get(Expression<String>("to_area_id")))
        self.fareProductID = .init(try row.get(Expression<String>("fare_product_id")))
        let fromServiceID = try row.get(Expression<String?>("from_timeframe_group_id"))
        
        if let fromServiceID {
            self.fromServiceID = .init(fromServiceID)
        }
        
        let toServiceID = try row.get(Expression<String?>("to_timeframe_group_id"))
        
        if let toServiceID {
            self.toServiceID = .init(toServiceID)
        }
    }
}
