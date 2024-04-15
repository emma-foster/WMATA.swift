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
    public init(publisherName: String, publisherURL: URL, language: String, startDate: Date? = nil, endDate: Date? = nil) {
        self.publisherName = publisherName
        self.publisherURL = publisherURL
        self.language = language
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension GTFSFeedInfo: SimpleQueryable {
    static let primaryKeyColumn = Expression<String>("feed_publisher_name")
    
    static let table = Table("feed_info")
    
    public var id: GTFSIdentifier<GTFSFeedInfo> { .init(publisherName) }
    
    init(row: Row) throws {
        self.publisherName = try row.get(Expression<String>("feed_publisher_name"))
        self.publisherURL = try row.get(Expression<URL>("feed_publisher_url"))
        self.language = try row.get(Expression<String>("feed_lang"))
        
        if let startDate = try row.get(Expression<Int?>("feed_start_date")) {
            self.startDate = Date(from8CharacterString: String(startDate))
        }
        
        if let endDate = try row.get(Expression<Int?>("feed_end_date")) {
            self.endDate = Date(from8CharacterString: String(endDate))
        }
    }
}
