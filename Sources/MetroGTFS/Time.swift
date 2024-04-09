//
//  Time.swift
//
//
//  Created by Emma on 4/8/24.
//

import Foundation

/// A time used in `stop_times.txt` to represent the arrival and departure times from a specific ``GTFSStop``.
///
/// This type exists to support the hour values greater than 24 used by the `arrivalTime` and `departureTime` used by `stop_times.txt`.
///
/// See [stop_times.txt docs](https://gtfs.org/schedule/reference/#stop_timestxt)
public struct GTFSTime: Equatable, Hashable, Codable, Sendable {
    
    /// The hour a timepoint occurs at in `stop_times.txt`.  A non-negative number, can be greater than 24, denoting the timepoint occurs after midnight on a particular service date.
    public var hours: Int
    
    /// The minutes a timepoint occurs at.
    public var minutes: Int
    
    /// The seconds a timepoint occurs at
    public var seconds: Int
}

extension GTFSTime: RawRepresentable {
    
    /// This timepoint as represented in `stop_times.txt`.
    public var rawValue: String {
        [self.hours, self.minutes, self.seconds].map { String($0) }.joined()
    }
    
    /// Create a timepoint from the GTFS value provided in `stop_times.txt`.
    public init?(rawValue: String) {
        var timeSegments = rawValue.split(separator: ":").map { String($0) }
        timeSegments.reverse()
        
        guard let hours = parseSegment(from: &timeSegments) else {
            return nil
        }
        
        self.hours = hours
        
        guard let minutes = parseSegment(from: &timeSegments) else {
            return nil
        }
        
        self.minutes = minutes
        
        guard let seconds = parseSegment(from: &timeSegments) else {
            return nil
        }
        
        self.seconds = seconds
    }
    
    var dateComponents: DateComponents {
        .init(hour: hours, minute: minutes, second: seconds)
    }
}

extension GTFSTime: Comparable {
    public static func < (lhs: GTFSTime, rhs: GTFSTime) -> Bool {
        lhs.hours < rhs.hours || lhs.minutes < rhs.minutes || lhs.seconds < rhs.seconds
    }
}


func parseSegment(from timeSegments: inout [String]) -> Int? {
    guard let segment = timeSegments.popLast() else {
        return nil
    }
    
    guard let segment = Int(segment) else {
       return nil
    }
    
    return segment
}
