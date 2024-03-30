//
//  FareMedia.swift
//
//
//  Created by Emma on 3/30/24.
//

import Foundation
import SQLite

public struct GTFSFareMedia: Equatable, Hashable, Codable {
    
    /// A unique identifier for this fare media.
    ///
    /// For WMATA, this represents Smartrip cards and phone apps.
    ///
    /// [See GTFS fare_media.txt docs](https://gtfs.org/schedule/reference/#fare_mediatxt)
    ///
    /// ## Examples
    ///
    /// ```
    /// "smartrip_card"
    /// "smartrip_app"
    /// ```
    public var id: GTFSIdentifier<GTFSFareMedia>
    
    /// The user-presentable name for this type of fare media.
    ///
    /// For WMATA, this is always `Smartrip`.
    public var name: String
    
    /// The different ways to pay for transit
    public enum FareMediaType: Int, Equatable, Hashable, Codable {
        
        ///  None. Used when there is no fare media involved in purchasing or validating a fare product, such as paying cash to a driver or conductor with no physical ticket provided.
        case none = 0
        
        /// Physical paper ticket that allows a passenger to take either a certain number of pre-purchased trips or unlimited trips within a fixed period of time.
        case physicalPaperTicket
        
        /// Physical transit card that has stored tickets, passes or monetary value.
        case physicalTransitCard
        
        /// cEMV (contactless Europay, Mastercard and Visa) as an open-loop token container for account-based ticketing.
        case contactlessEMV
        
        /// Alias for ``contactlessEMV``
        static let creditCard = contactlessEMV
        
        /// Alias for ``contactlessEMV``
        static let debitCard = contactlessEMV
        
        /// Alias for ``contactlessEMV``
        static let europay = contactlessEMV
        
        /// Mobile app that have stored virtual transit cards, tickets, passes, or monetary value.
        case mobileApp
    }
    
    /// What format this fare media is. Example: physical transit card, app, or paper tickets
    public var mediaType: FareMediaType
    
    /// Create a new fare media by providing all of it's properties
    public init(id: GTFSIdentifier<GTFSFareMedia>, name: String, mediaType: FareMediaType) {
        self.id = id
        self.name = name
        self.mediaType = mediaType
    }
}

extension GTFSFareMedia: GTFSStructure {
    enum TableColumn {
        static let id = Expression<String>("fare_media_id")
        static let name = Expression<String>("fare_media_name")
        static let mediaType = Expression<Int>("fare_media_type")
    }
    
    static let databaseTable = GTFSDatabase.Table(
        sqlTable: SQLite.Table("fare_media"),
        primaryKeyColumn: TableColumn.id
    )
    
    init(row: Row) throws {
        self.id = .init(try row.get(TableColumn.id))
        self.name = try row.get(TableColumn.name)
        
        let mediaType = try row.get(TableColumn.mediaType)
        
        guard let mediaType = FareMediaType(rawValue: mediaType) else {
            throw GTFSDatabaseDecodingError.invalidEntry(structureType: GTFSFareMedia.self, key: "fare_media_type")
        }
        
        self.mediaType = mediaType
    }
}
