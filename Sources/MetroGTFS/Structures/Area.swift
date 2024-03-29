//
//  Area.swift
//
//
//  Created by Emma on 3/29/24.
//

import Foundation
import SQLite

public struct GTFSArea: Equatable, Hashable, Codable {
    
    /// A unique ID for the area. For WMATA, this is a Station Code (or multiple for transfer stations) prefixed by `STN_`.
    ///
    /// ## Example
    ///
    /// `STN_A02` // Farragut North
    /// `STN_B01_F01` // Gallery Place
    public var id: GTFSIdentifier<GTFSArea>
    
    /// Create a new area by providing all of it's properties
    public init(id: GTFSIdentifier<GTFSArea>) {
        self.id = id
    }
}

extension GTFSArea: GTFSStructure {
    enum TableColumn {
        static let id = Expression<String>("area_id")
    }
    
    static let databaseTable = GTFSDatabase.Table(
        sqlTable: SQLite.Table("areas"),
        primaryKeyColumn: TableColumn.id
    )
    
    init(row: Row) throws {
        self.id = .init(try row.get(TableColumn.id))
    }
}
