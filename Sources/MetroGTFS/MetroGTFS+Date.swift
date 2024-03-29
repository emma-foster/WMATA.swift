//
//  MetroGTFS+Date.swift
//
//
//  Created by Emma on 3/26/24.
//

import Foundation

extension Date {
    /// Create a `Date` from the 8 character string provided in GTFS data.
    ///
    /// ## Example
    ///
    /// ```
    /// Date(from8CharacterString: "20240305")
    /// ```
    init?(from8CharacterString dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyymmdd"
        
        let date = dateFormatter.date(from: dateString)
        
        if let date {
            self = date
        } else {
            return nil
        }
    }
    
    /// Create a `Date` from the 8 digit int provided in GTFS data.
    ///
    /// ## Example
    ///
    /// ```
    /// Date(from8CharacterNumber: 20240305)
    /// ```
    init?(from8CharacterNumber dateNumber: Int) {
        self.init(from8CharacterString: String(dateNumber))
    }
    
    /// Convert this date into an 8 character string, like the format used in GTFS data
    ///
    /// ## Example
    ///
    /// ```
    /// let myDate = Date(from8CharacterNumber: 20240305)
    /// myDate.as8CharacterString() // "20240305"
    /// ```
    func as8CharacterString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyymmdd"
        
        return dateFormatter.string(from: self)
    }
    
    /// Convert this date into an 8 character number, like the format used in GTFS data
    ///
    /// ## Example
    ///
    /// ```
    /// let myDate = Date(from8CharacterNumber: 20240305)
    /// myDate.as8CharacterNumber() // 20240305
    /// ```
    func as8CharacterNumber() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyymmdd"
        
        return Int(dateFormatter.string(from: self))!
    }
}
