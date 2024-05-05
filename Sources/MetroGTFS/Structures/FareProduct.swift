//
//  FareProduct.swift
//
//
//  Created by Emma on 3/30/24.
//

import Foundation
import SQLite

/// A way to pay for transit. Describes unlimited passes and all possible costs for a trip & what ``GTFSFareMedia`` can
/// be used to pay for trips.
///
/// See [GTFS fare_product.txt docs](https://gtfs.org/schedule/reference/#fare_productstxt)
///
/// ## Example
/// ```
/// let fareProduct = try GTFSFareProduct("7_day_unlimited_Pass")
///
/// fareProduct.amount // 58.00
/// fareProduct.fareMediaID // GTFSIdentifier<GTFSFareMedia>("smartrip_card")
/// ```
public struct GTFSFareProduct: Equatable, Hashable, Codable {
    
    /// A unique identifier for this fare product
    public var fareProductID: GTFSIdentifier<GTFSFareProduct>
    
    /// The human readable name of this fare product
    public var name: String
    
    /// The fare media that can be used to use this fare product
    ///
    /// For WMATA, this is always `smartrip_card`, not `smartrip_app`.
    /// However, this is likely a bug as the app can be used for all of the described fare products
    public var fareMediaID: GTFSIdentifier<GTFSFareMedia>
    
    /// The cost of this fare product
    public var amount: Double
    
    /// The currency ``amount`` is in.
    ///
    /// For WMATA, this is always `USD`.
    public var currency: String
    
    /// Create a fare product by providing all of it's fields
    public init(fareProductID: GTFSIdentifier<GTFSFareProduct>, name: String, fareMediaID: GTFSIdentifier<GTFSFareMedia>, amount: Double, currency: String) {
        self.fareProductID = fareProductID
        self.name = name
        self.fareMediaID = fareMediaID
        self.amount = amount
        self.currency = currency
    }
    
    /// Query the database for a fare product given the fare product ID and fare media ID
    public init(_ fareProductID: @autoclosure @escaping () -> String, fareMediaID: @autoclosure @escaping (() -> String) = { "smartrip_card" }()) throws {
        try self.init(GTFSIdentifier<GTFSFareProduct>(fareProductID()), GTFSIdentifier<GTFSFareMedia>(fareMediaID()))
    }
}

extension GTFSFareProduct: CompositeKeyQueryable {
    static let table = Table("fare_products")
    
    static func createPrimaryKeyQuery<P1, P2>(_ primaryKey1: P1, _ primaryKey2: P2) -> Table where P1 : Value, P2 : Value, P1.Datatype : Equatable, P2.Datatype : Equatable {
        table.filter(Expression<P1>("fare_product_id") == primaryKey1 && Expression<P2>("fare_media_id") == primaryKey2)
    }
    
    init(row: Row) throws {
        self.fareProductID = .init(try row.get(Expression<String>("fare_product_id")))
        self.name = try row.get(Expression<String>("fare_product_name"))
        self.fareMediaID = .init(try row.get(Expression<String>("fare_media_id")))
        self.amount = try row.get(Expression<Double>("amount"))
        self.currency = try row.get(Expression<String>("currency"))
    }
}

@available(tvOS 16, *)
@available(watchOS 9, *)
@available(iOS 16, *)
@available(macOS 13, *)
extension GTFSFareProduct {
    var currencyLocale: Locale.Currency {
        .init("usd")
    }
}
