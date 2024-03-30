//
//  FeedInfo.swift
//
//
//  Created by Emma on 3/23/24.
//

import Foundation
import SQLite

/// Information about the GTFS dataset. Includes details about who publishes the dataset and over what time period it's valid.
///
/// More info available at [feed_info.txt docs](https://gtfs.org/schedule/reference/#feed_infotxt)
///
/// ## Example
///
/// ```
/// let feedInfo = try GTFSFeedInfo("WMATA")
///
/// feedInfo.endDate // the last date this dataset is valid for
/// ```
public struct GTFSFeedInfo: Equatable, Hashable, Codable {
    /// The human readable name of the organization that publishes this GTFS dataset
    public var publisherName: String
    
    /// The public URL for the website of the organization that publishes this GTFS dataset
    public var publisherURL: URL
    
    /// The spoken language this GTFS dataset is published in
    public var language: String
    
    /// The first date this GTFS dataset provides schedule information for
    public var startDate: Date?
    
    /// The last date this GTFS dataset provides schedule information for
    public var endDate: Date?
    
    /// Create a new GTFS Feed Info by providing all of it's fields
    init(publisherName: String, publisherURL: URL, language: String, startDate: Date? = nil, endDate: Date? = nil) {
        self.publisherName = publisherName
        self.publisherURL = publisherURL
        self.language = language
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension GTFSFeedInfo: GTFSStructure {
    public var id: GTFSIdentifier<GTFSFeedInfo> { .init(publisherName) }
    
    enum TableColumn {
        static let publisherName = Expression<String>("feed_publisher_name")
        static let publisherURL = Expression<URL>("feed_publisher_url")
        static let language = Expression<String>("feed_lang")
        static let startDate = Expression<Int?>("feed_start_date")
        static let endDate = Expression<Int?>("feed_end_date")
    }
    
    static let databaseTable = GTFSDatabase.Table(
        sqlTable: SQLite.Table("feed_info"),
        primaryKeyColumn: GTFSFeedInfo.TableColumn.publisherName
    )
    
    init(row: Row) throws {
        do {
            self.publisherName = try row.get(TableColumn.publisherName)
            self.publisherURL = try row.get(TableColumn.publisherURL)
            self.language = try row.get(TableColumn.language)
            
            if let startDate = try row.get(TableColumn.startDate) {
                self.startDate = Date(from8CharacterString: String(startDate))
            }
            
            if let endDate = try row.get(TableColumn.endDate) {
                self.endDate = Date(from8CharacterString: String(endDate))
            }
        } catch {
            print(error)
            throw GTFSDatabaseError.invalid(row)
        }
    }
}
