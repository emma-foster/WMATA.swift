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
    public init(fareProductID: GTFSIdentifier<GTFSFareProduct>, fareMediaID: GTFSIdentifier<GTFSFareMedia> = .init("smartrip_card")) throws {
        try self.init(where: GTFSFareProduct.databaseTable.sqlTable
            .filter(TableColumn.fareProductID == fareProductID.rawValue)
            .filter(TableColumn.fareMediaID == fareMediaID.rawValue)
        )
    }
    
    /// Query the database for a fare product given the fare product ID and fare media ID
    public init(_ fareProductID: @autoclosure @escaping () -> String, fareMediaID: @autoclosure @escaping (() -> String?) = nil) throws {
        try self.init(fareProductID: .init(fareProductID()), fareMediaID: .init(fareMediaID() ?? "smartrip_card"))
    }
}

extension GTFSFareProduct: GTFSStructure {
    var id: GTFSIdentifier<GTFSFareProduct> {
        .init("\(self.fareProductID), \(self.fareMediaID)")
    }
    
    enum TableColumn {
        static let fareProductID = Expression<String>("fare_product_id")
        static let name = Expression<String>("fare_product_name")
        static let fareMediaID = Expression<String>("fare_media_id")
        static let amount = Expression<Double>("amount")
        static let currency = Expression<String>("currency")
    }
    
    static let databaseTable = GTFSDatabase.Table(
        sqlTable: SQLite.Table("fare_products"),
        primaryKeyColumn: TableColumn.fareProductID
    )
    
    init(row: Row) throws {
        self.fareProductID = .init(try row.get(TableColumn.fareProductID))
        self.name = try row.get(TableColumn.name)
        self.fareMediaID = .init(try row.get(TableColumn.fareMediaID))
        self.amount = try row.get(TableColumn.amount)
        self.currency = try row.get(TableColumn.currency)
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
