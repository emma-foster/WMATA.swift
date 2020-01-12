//
//  Stations.swift
//  
//
//  Created by Emma K Alexandra on 10/6/19.
//

import Foundation

/// Station codes as defined by WMATA
public enum Station: String, CaseIterable, Codable {
    case A01
    case A02
    case A03
    case A04
    case A05
    case A06
    case A07
    case A08
    case A09
    case A10
    case A11
    case A12
    case A13
    case A14
    case A15
    case B01
    case B02
    case B03
    case B04
    case B05
    case B06
    case B07
    case B08
    case B09
    case B10
    case B11
    case B35
    case C01
    case C02
    case C03
    case C04
    case C05
    case C06
    case C07
    case C08
    case C09
    case C10
    case C12
    case C13
    case C14
    case C15
    case D01
    case D02
    case D03
    case D04
    case D05
    case D06
    case D07
    case D08
    case D09
    case D10
    case D11
    case D12
    case D13
    case E01
    case E02
    case E03
    case E04
    case E05
    case E06
    case E07
    case E08
    case E09
    case E10
    case F01
    case F02
    case F03
    case F04
    case F05
    case F06
    case F07
    case F08
    case F09
    case F10
    case F11
    case G01
    case G02
    case G03
    case G04
    case G05
    case J02
    case J03
    case K01
    case K02
    case K03
    case K04
    case K05
    case K06
    case K07
    case K08
    case N01
    case N02
    case N03
    case N04
    case N06
}

extension Station: NeedsStation {
    /// Distance, fare information, and estimated travel time between this and another station.
    /// - Parameter destinationStation: Optional. Station to travel to
    /// - Parameter apiKey: WMATA API Key to use with this request
    /// - Parameter session: Optional. URL Session to make this request with
    /// - Parameter completion: completion that returns `StationToStationInfos`
    public func station(to destinationStation: Station?, withApiKey apiKey: String, andSession session: URLSession = URLSession.shared, completion: @escaping (Result<StationToStationInfos, WMATAError>) -> ()) {
        (self as NeedsStation).station(self, to: destinationStation, withApiKey: apiKey, andSession: session, completion: completion)
        
    }
    
    /// Reported elevator and escalator incidents at this Station
    /// - Parameter apiKey: WMATA API Key to use with this request
    /// - Parameter session: Optional. URL Session to make this request with
    /// - Parameter completion: completion handler that returns `ElevatorAndEscalatorIncidents`
    public func elevatorAndEscalatorIncidents(withApiKey apiKey: String, andSession session: URLSession = URLSession.shared, completion: @escaping (Result<ElevatorAndEscalatorIncidents, WMATAError>) -> ()) {
        (self as NeedsStation).elevatorAndEscalatorIncidents(at: self, withApiKey: apiKey, andSession: session, completion: completion)
        
    }
    
    /// Reported MetroRail incidents at this Station
    /// - Parameter apiKey: WMATA API Key to use with this request
    /// - Parameter session: Optional. URL Session to make this request with
    /// - Parameter completion: completion handler that returns `RailIncidents`
    public func incidents(withApiKey apiKey: String, andSession session: URLSession = URLSession.shared, completion: @escaping (Result<RailIncidents, WMATAError>) -> ()) {
        (self as NeedsStation).incidents(at: self, withApiKey: apiKey, andSession: session, completion: completion)
        
    }
    
    ///  Next train arrival information for this Station
    /// - Parameter apiKey: WMATA API Key to use with this request
    /// - Parameter session: Optional. URL Session to make this request with
    /// - Parameter completion: completion handler that returns `RailPredictions`
    public func nextTrains(withApiKey apiKey: String, andSession session: URLSession = URLSession.shared, completion: @escaping (Result<RailPredictions, WMATAError>) -> ()) {
        (self as NeedsStation).nextTrains(at: self, withApiKey: apiKey, andSession: session, completion: completion)
        
    }
    
    /// Location and address information for this Station
    /// - Parameter apiKey: WMATA API Key to use with this request
    /// - Parameter session: Optional. URL Session to make this request with
    /// - Parameter completion: completion handler that returns `StationInformation`
    public func information(withApiKey apiKey: String, andSession session: URLSession = URLSession.shared, completion: @escaping (Result<StationInformation, WMATAError>) -> ()) {
        (self as NeedsStation).information(for: self, withApiKey: apiKey, andSession: session, completion: completion)
        
    }
    
    /// Parking information for this Station
    /// - Parameter apiKey: WMATA API Key to use with this request
    /// - Parameter session: Optional. URL Session to make this request with
    /// - Parameter completion: completion handler that returns `StationsParking`
    public func parkingInformation(withApiKey apiKey: String, andSession session: URLSession = URLSession.shared, completion: @escaping (Result<StationsParking, WMATAError>) -> ()) {
        (self as NeedsStation).parkingInformation(for: self, withApiKey: apiKey, andSession: session, completion: completion)
        
    }
    
    /// Returns a set of ordered stations and distances from this Station to another Station _on the same line_
    /// - Parameter destinationStation: Destination station to pathfind to
    /// - Parameter apiKey: WMATA API Key to use with this request
    /// - Parameter session: Optional. URL Session to make this request with
    /// - Parameter completion: completion handler that returns `PathBetweenStations`
    public func path(to destinationStation: Station, withApiKey apiKey: String, andSession session: URLSession = URLSession.shared, completion: @escaping (Result<PathBetweenStations, WMATAError>) -> ()) {
        (self as NeedsStation).path(from: self, to: destinationStation, withApiKey: apiKey, andSession: session, completion: completion)
        
    }
    
    /// Opening and scheduled first and last trains for this Station
    /// - Parameter apiKey: WMATA API Key to use with this request
    /// - Parameter session: Optional. URL Session to make this request with
    /// - Parameter completion: completion handler that returns `StationTimings`
    public func timings(withApiKey apiKey: String, andSession session: URLSession = URLSession.shared, completion: @escaping (Result<StationTimings, WMATAError>) -> ()) {
        (self as NeedsStation).timings(for: self, withApiKey: apiKey, andSession: session, completion: completion)
        
    }
    
}

extension Station {
    /// A human readable and presentable station name
    public var name: String {
        switch self {
        case .A01:
            return "Metro Center"
            
        case .A02:
            return "Farragut North"
            
        case .A03:
            return "Dupont Circle"
            
        case .A04:
            return "Woodley Park-Zoo/Adams Morgan"
            
        case .A05:
            return "Cleveland Park"
            
        case .A06:
            return "Van Ness-UDC"
            
        case .A07:
            return "Tenleytown-AU"
            
        case .A08:
            return "Friendship Heights"
            
        case .A09:
            return "Bethesda"
            
        case .A10:
            return "Medical Center"
            
        case .A11:
            return "Grosvenor-Strathmore"
            
        case .A12:
            return "White Flint"
            
        case .A13:
            return "Twinbrook"
            
        case .A14:
            return "Rockville"
            
        case .A15:
            return "Shady Grove"
            
        case .B01:
            return "Gallery Pl-Chinatown"
            
        case .B02:
            return "Judiciary Square"
            
        case .B03:
            return "Union Station"
            
        case .B04:
            return "Rhode Island Ave-Brentwood"
            
        case .B05:
            return "Brookland-CUA"
            
        case .B06:
            return "Fort Totten"
            
        case .B07:
            return "Takoma"
            
        case .B08:
            return "Silver Spring"
            
        case .B09:
            return "Forest Glen"
            
        case .B10:
            return "Wheaton"
            
        case .B11:
            return "Glenmont"
            
        case .B35:
            return "NoMa-Gallaudet U"
            
        case .C01:
            return "Metro Center"
            
        case .C02:
            return "McPherson Square"
            
        case .C03:
            return "Farragut West"
            
        case .C04:
            return "Foggy Bottom-GWU"
            
        case .C05:
            return "Rosslyn"
            
        case .C06:
            return "Arlington Cemetery"
            
        case .C07:
            return "Pentagon"
            
        case .C08:
            return "Pentagon City"
            
        case .C09:
            return "Crystal City"
            
        case .C10:
            return "Ronald Reagan Washington National Airport"
            
        case .C12:
            return "Braddock Road"
            
        case .C13:
            return "King St-Old Town"
            
        case .C14:
            return "Eisenhower Avenue"
            
        case .C15:
            return "Huntington"
            
        case .D01:
            return "Federal Triangle"
            
        case .D02:
            return "Smithsonian"
            
        case .D03:
            return "L'Enfant Plaza"
            
        case .D04:
            return "Federal Center SW"
            
        case .D05:
            return "Capitol South"
            
        case .D06:
            return "Eastern Market"
            
        case .D07:
            return "Potomac Ave"
            
        case .D08:
            return "Stadium-Armory"
            
        case .D09:
            return "Minnesota Ave"
            
        case .D10:
            return "Deanwood"
            
        case .D11:
            return "Cheverly"
            
        case .D12:
            return "Landover"
            
        case .D13:
            return "New Carrollton"
            
        case .E01:
            return "Mt Vernon Sq 7th St-Convention Center"
            
        case .E02:
            return "Shaw-Howard U"
            
        case .E03:
            return "U Street/African-Amer Civil War Memorial/Cardozo"
            
        case .E04:
            return "Columbia Heights"
            
        case .E05:
            return "Georgia Ave-Petworth"
            
        case .E06:
            return "Fort Totten"
            
        case .E07:
            return "West Hyattsville"
            
        case .E08:
            return "Prince George's Plaza"
            
        case .E09:
            return "College Park-U of Md"
            
        case .E10:
            return "Greenbelt"
            
        case .F01:
            return "Gallery Pl-Chinatown"
            
        case .F02:
            return "Archives-Navy Memorial-Penn Quarter"
            
        case .F03:
            return "L'Enfant Plaza"
            
        case .F04:
            return "Waterfront"
            
        case .F05:
            return "Navy Yard-Ballpark"
            
        case .F06:
            return "Anacostia"
            
        case .F07:
            return "Congress Heights"
            
        case .F08:
            return "Southern Avenue"
            
        case .F09:
            return "Naylor Road"
            
        case .F10:
            return "Suitland"
            
        case .F11:
            return "Branch Ave"
            
        case .G01:
            return "Benning Road"
            
        case .G02:
            return "Capitol Heights"
            
        case .G03:
            return "Addison Road-Seat Pleasant"
            
        case .G04:
            return "Morgan Boulevard"
            
        case .G05:
            return "Largo Town Center"
            
        case .J02:
            return "Van Dorn Street"
            
        case .J03:
            return "Franconia-Springfield"
            
        case .K01:
            return "Court House"
            
        case .K02:
            return "Clarendon"
            
        case .K03:
            return "Virginia Square-GMU"
            
        case .K04:
            return "Ballston-MU"
            
        case .K05:
            return "East Falls Church"
            
        case .K06:
            return "West Falls Church-VT/UVA"
            
        case .K07:
            return "Dunn Loring-Merrifield"
            
        case .K08:
            return "Vienna/Fairfax-GMU"
            
        case .N01:
            return "McLean"
            
        case .N02:
            return "Tysons Corner"
            
        case .N03:
            return "Greensboro"
            
        case .N04:
            return "Spring Hill"
            
        case .N06:
            return "Wiehle-Reston East"
            
        }
        
    }
    
    /// The `Line`s this station is on
    public var lines: [Line] {
        switch self {
        case .A01, .C01:
            return [.BL, .OR, .SV, .RD]
            
        case .A02, .A03, .A04, .A05, .A06, .A07, .A08, .A09, .A10, .A11, .A12, .A13, .A14, .A15, .B02, .B03, .B04, .B05, .B07, .B08, .B09, .B10, .B11, .B35:
            return [.RD]
            
        case .B01, .B06, .E06, .F01:
            return [.RD, .YL, .GR]
            
        case .C02, .C03, .C04, .C05, .D01, .D02, .D04, .D05, .D06, .D07, .D08:
            return [.BL, .OR, .SV]
            
        case .C06, .J02, .J03:
            return [.BL]
            
        case .C07, .C08, .C09, .C10, .C12, .C13:
            return [.BL, .YL]
            
        case .C14, .C15:
            return [.YL]
            
        case .D03, .F03:
            return [.GR, .YL, .BL, .OR, .SV]
            
        case .D09, .D10, .D11, .D12, .D13, .K06, .K07, .K08:
            return [.OR]
            
        case .E01, .E02, .E03, .E04, .E05, .E07, .E08, .E09, .E10, .F02:
            return [.GR, .YL]
            
        case .F04, .F05, .F06, .F07, .F08, .F09, .F10, .F11:
            return [.GR]
            
        case .G01, .G02, .G03, .G04, .G05:
            return [.BL, .SV]
            
        case .K01, .K02, .K03, .K04, .K05:
            return [.OR, .SV]
            
        case .N01, .N02, .N03, .N04, .N06:
            return [.SV]
            
        }
        
    }
    
    /// The opening time for this station on the given date.
    /// - Parameter date: Date to check the opening time for. Omit for today.
    /// - Returns: The time
    public func openingTime(on date: Date? = nil) -> Date {
        let day: WeekdaySaturdayOrSunday
        let openingDate: Date
        
        if let date = date {
            (day, openingDate) = (date.weekdaySaturdayOrSunday(), date)
            
            
        } else {
            openingDate = Date()
            day = openingDate.weekdaySaturdayOrSunday()
            
        }
        
        let openingTimeDateComponents = Station.openingTimes[self]![day]!
        let openingDateComponents = Calendar(identifier: .gregorian).dateComponents([.day, .month, .year, .timeZone, .calendar], from: openingDate)
        
        return DateComponents(
            calendar: openingDateComponents.calendar,
            timeZone: openingDateComponents.timeZone!,
            year: openingDateComponents.year!,
            month: openingDateComponents.month!,
            day: openingDateComponents.day!,
            hour: openingTimeDateComponents.hour!,
            minute: openingTimeDateComponents.minute!
        ).date!
        
        
    }
    
}

extension Station: CustomStringConvertible {
    public var description: String {
        self.rawValue
        
    }
    
}

extension Station {
    private static var openingTimes: [Station: [WeekdaySaturdayOrSunday: DateComponents]] = [
        .A01: [
            .sunday: DateComponents(hour: 8, minute: 14),
            .weekday: DateComponents(hour: 5, minute: 14),
            .saturday: DateComponents(hour: 7, minute: 14)
        ],
        .A02: [
            .sunday: DateComponents(hour: 8, minute: 24),
            .weekday: DateComponents(hour: 5, minute: 24),
            .saturday: DateComponents(hour: 7, minute: 24)
        ],
        .A03: [
            .sunday: DateComponents(hour: 8, minute: 23),
            .weekday: DateComponents(hour: 5, minute: 23),
            .saturday: DateComponents(hour: 7, minute: 23)
        ],
        .A04: [
            .sunday: DateComponents(hour: 8, minute: 21),
            .weekday: DateComponents(hour: 5, minute: 21),
            .saturday: DateComponents(hour: 7, minute: 21)
        ],
        .A05: [
            .sunday: DateComponents(hour: 8, minute: 19),
            .weekday: DateComponents(hour: 5, minute: 19),
            .saturday: DateComponents(hour: 7, minute: 19)
        ],
        .A06: [
            .sunday: DateComponents(hour: 8, minute: 17),
            .weekday: DateComponents(hour: 5, minute: 17),
            .saturday: DateComponents(hour: 7, minute: 17)
        ],
        .A07: [
            .sunday: DateComponents(hour: 8, minute: 14),
            .weekday: DateComponents(hour: 5, minute: 14),
            .saturday: DateComponents(hour: 7, minute: 14)
        ],
        .A08: [
            .sunday: DateComponents(hour: 8, minute: 12),
            .weekday: DateComponents(hour: 5, minute: 12),
            .saturday: DateComponents(hour: 7, minute: 12)
        ],
        .A09: [
            .sunday: DateComponents(hour: 8, minute: 9),
            .weekday: DateComponents(hour: 5, minute: 9),
            .saturday: DateComponents(hour: 7, minute: 9)
        ],
        .A10: [
            .sunday: DateComponents(hour: 8, minute: 6),
            .weekday: DateComponents(hour: 5, minute: 6),
            .saturday: DateComponents(hour: 7, minute: 6)
        ],
        .A11: [
            .sunday: DateComponents(hour: 8, minute: 3),
            .weekday: DateComponents(hour: 5, minute: 3),
            .saturday: DateComponents(hour: 7, minute: 3)
        ],
        .A12: [
            .sunday: DateComponents(hour: 8, minute: 0),
            .weekday: DateComponents(hour: 5, minute: 0),
            .saturday: DateComponents(hour: 7, minute: 0)
        ],
        .A13: [
            .sunday: DateComponents(hour: 7, minute: 57),
            .weekday: DateComponents(hour: 4, minute: 57),
            .saturday: DateComponents(hour: 6, minute: 57)
        ],
        .A14: [
            .sunday: DateComponents(hour: 7, minute: 54),
            .weekday: DateComponents(hour: 4, minute: 54),
            .saturday: DateComponents(hour: 6, minute: 54)
        ],
        .A15: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50)
        ],
        .B01: [
            .sunday: DateComponents(hour: 8, minute: 15),
            .weekday: DateComponents(hour: 5, minute: 15),
            .saturday: DateComponents(hour: 7, minute: 15)
        ],
        .B02: [
            .sunday: DateComponents(hour: 8, minute: 17),
            .weekday: DateComponents(hour: 5, minute: 17),
            .saturday: DateComponents(hour: 7, minute: 17)
        ],
        .B03: [
            .sunday: DateComponents(hour: 8, minute: 15),
            .weekday: DateComponents(hour: 5, minute: 15),
            .saturday: DateComponents(hour: 7, minute: 15)
        ],
        .B04: [
            .sunday: DateComponents(hour: 8, minute: 11),
            .weekday: DateComponents(hour: 5, minute: 11),
            .saturday: DateComponents(hour: 7, minute: 11)
        ],
        .B05: [
            .sunday: DateComponents(hour: 8, minute: 8),
            .weekday: DateComponents(hour: 5, minute: 8),
            .saturday: DateComponents(hour: 7, minute: 8)
        ],
        .B06: [
            .sunday: DateComponents(hour: 8, minute: 0),
            .weekday: DateComponents(hour: 5, minute: 0),
            .saturday: DateComponents(hour: 7, minute: 0)
        ],
        .B07: [
            .sunday: DateComponents(hour: 8, minute: 2),
            .weekday: DateComponents(hour: 5, minute: 2),
            .saturday: DateComponents(hour: 7, minute: 2)
        ],
        .B08: [
            .sunday: DateComponents(hour: 7, minute: 59),
            .weekday: DateComponents(hour: 4, minute: 59),
            .saturday: DateComponents(hour: 6, minute: 59)
        ],
        .B09: [
            .sunday: DateComponents(hour: 7, minute: 56),
            .weekday: DateComponents(hour: 4, minute: 56),
            .saturday: DateComponents(hour: 6, minute: 56)
        ],
        .B10: [
            .sunday: DateComponents(hour: 7, minute: 53),
            .weekday: DateComponents(hour: 4, minute: 53),
            .saturday: DateComponents(hour: 6, minute: 53)
        ],
        .B11: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50)
        ],
        .B35: [
            .sunday: DateComponents(hour: 8, minute: 13),
            .weekday: DateComponents(hour: 5, minute: 13),
            .saturday: DateComponents(hour: 7, minute: 13)
        ],
        .C01: [
            .sunday: DateComponents(hour: 8, minute: 14),
            .weekday: DateComponents(hour: 5, minute: 14),
            .saturday: DateComponents(hour: 7, minute: 14)
        ],
        .C02: [
            .sunday: DateComponents(hour: 8, minute: 16),
            .weekday: DateComponents(hour: 5, minute: 16),
            .saturday: DateComponents(hour: 7, minute: 16)
        ],
        .C03: [
            .sunday: DateComponents(hour: 8, minute: 18),
            .weekday: DateComponents(hour: 5, minute: 18),
            .saturday: DateComponents(hour: 7, minute: 18)
        ],
        .C04: [
            .sunday: DateComponents(hour: 8, minute: 16),
            .weekday: DateComponents(hour: 5, minute: 16),
            .saturday: DateComponents(hour: 7, minute: 16)
        ],
        .C05: [
            .sunday: DateComponents(hour: 8, minute: 17),
            .weekday: DateComponents(hour: 5, minute: 17),
            .saturday: DateComponents(hour: 7, minute: 17)
        ],
        .C06: [
            .sunday: DateComponents(hour: 8, minute: 17),
            .weekday: DateComponents(hour: 5, minute: 17),
            .saturday: DateComponents(hour: 7, minute: 17)
        ],
        .C07: [
            .sunday: DateComponents(hour: 8, minute: 7),
            .weekday: DateComponents(hour: 5, minute: 7),
            .saturday: DateComponents(hour: 7, minute: 7)
        ],
        .C08: [
            .sunday: DateComponents(hour: 8, minute: 5),
            .weekday: DateComponents(hour: 5, minute: 5),
            .saturday: DateComponents(hour: 7, minute: 5)
        ],
        .C09: [
            .sunday: DateComponents(hour: 8, minute: 3),
            .weekday: DateComponents(hour: 5, minute: 3),
            .saturday: DateComponents(hour: 7, minute: 3)
        ],
        .C10: [
            .sunday: DateComponents(hour: 8, minute: 1),
            .weekday: DateComponents(hour: 5, minute: 1),
            .saturday: DateComponents(hour: 7, minute: 1)
        ],
        .C12: [
            .sunday: DateComponents(hour: 7, minute: 56),
            .weekday: DateComponents(hour: 4, minute: 56),
            .saturday: DateComponents(hour: 6, minute: 56)
        ],
        .C13: [
            .sunday: DateComponents(hour: 7, minute: 54),
            .weekday: DateComponents(hour: 4, minute: 54),
            .saturday: DateComponents(hour: 6, minute: 54)
        ],
        .C14: [
            .sunday: DateComponents(hour: 7, minute: 52),
            .weekday: DateComponents(hour: 4, minute: 52),
            .saturday: DateComponents(hour: 6, minute: 52)
        ],
        .C15: [
            .sunday: DateComponents(hour: 8, minute: 50),
            .weekday: DateComponents(hour: 5, minute: 50),
            .saturday: DateComponents(hour: 7, minute: 50)
        ],
        .D01: [
            .sunday: DateComponents(hour: 8, minute: 13),
            .weekday: DateComponents(hour: 5, minute: 13),
            .saturday: DateComponents(hour: 7, minute: 13)
        ],
        .D02: [
            .sunday: DateComponents(hour: 8, minute: 11),
            .weekday: DateComponents(hour: 5, minute: 11),
            .saturday: DateComponents(hour: 7, minute: 11)
        ],
        .D03: [
            .sunday: DateComponents(hour: 8, minute: 9),
            .weekday: DateComponents(hour: 5, minute: 9),
            .saturday: DateComponents(hour: 7, minute: 9)
        ],
        .D04: [
            .sunday: DateComponents(hour: 8, minute: 7),
            .weekday: DateComponents(hour: 5, minute: 7),
            .saturday: DateComponents(hour: 7, minute: 7)
        ],
        .D05: [
            .sunday: DateComponents(hour: 8, minute: 5),
            .weekday: DateComponents(hour: 5, minute: 5),
            .saturday: DateComponents(hour: 7, minute: 5)
        ],
        .D06: [
            .sunday: DateComponents(hour: 8, minute: 3),
            .weekday: DateComponents(hour: 5, minute: 3),
            .saturday: DateComponents(hour: 7, minute: 3)
        ],
        .D07: [
            .sunday: DateComponents(hour: 8, minute: 1),
            .weekday: DateComponents(hour: 5, minute: 1),
            .saturday: DateComponents(hour: 7, minute: 1)
        ],
        .D08: [
            .sunday: DateComponents(hour: 7, minute: 59),
            .weekday: DateComponents(hour: 4, minute: 59),
            .saturday: DateComponents(hour: 6, minute: 59)
        ],
        .D09: [
            .sunday: DateComponents(hour: 8, minute: 0),
            .weekday: DateComponents(hour: 5, minute: 0),
            .saturday: DateComponents(hour: 7, minute: 0)
        ],
        .D10: [
            .sunday: DateComponents(hour: 7, minute: 58),
            .weekday: DateComponents(hour: 4, minute: 58),
            .saturday: DateComponents(hour: 6, minute: 58)
        ],
        .D11: [
            .sunday: DateComponents(hour: 7, minute: 56),
            .weekday: DateComponents(hour: 4, minute: 56),
            .saturday: DateComponents(hour: 6, minute: 56)
        ],
        .D12: [
            .sunday: DateComponents(hour: 7, minute: 53),
            .weekday: DateComponents(hour: 4, minute: 53),
            .saturday: DateComponents(hour: 6, minute: 53)
        ],
        .D13: [
            .sunday: DateComponents(hour: 7, minute: 59),
            .weekday: DateComponents(hour: 4, minute: 59),
            .saturday: DateComponents(hour: 6, minute: 59)
        ],
        .E01: [
            .sunday: DateComponents(hour: 8, minute: 14),
            .weekday: DateComponents(hour: 5, minute: 14),
            .saturday: DateComponents(hour: 7, minute: 14)
        ],
        .E02: [
            .sunday: DateComponents(hour: 8, minute: 13),
            .weekday: DateComponents(hour: 5, minute: 13),
            .saturday: DateComponents(hour: 7, minute: 13)
        ],
        .E03: [
            .sunday: DateComponents(hour: 8, minute: 11),
            .weekday: DateComponents(hour: 5, minute: 11),
            .saturday: DateComponents(hour: 7, minute: 11)
        ],
        .E04: [
            .sunday: DateComponents(hour: 8, minute: 9),
            .weekday: DateComponents(hour: 5, minute: 9),
            .saturday: DateComponents(hour: 7, minute: 9)
        ],
        .E05: [
            .sunday: DateComponents(hour: 8, minute: 6),
            .weekday: DateComponents(hour: 5, minute: 6),
            .saturday: DateComponents(hour: 7, minute: 6)
        ],
        .E06: [
            .sunday: DateComponents(hour: 8, minute: 0),
            .weekday: DateComponents(hour: 5, minute: 0),
            .saturday: DateComponents(hour: 7, minute: 0)
        ],
        .E07: [
            .sunday: DateComponents(hour: 7, minute: 59),
            .weekday: DateComponents(hour: 4, minute: 59),
            .saturday: DateComponents(hour: 6, minute: 59)
        ],
        .E08: [
            .sunday: DateComponents(hour: 7, minute: 56),
            .weekday: DateComponents(hour: 4, minute: 56),
            .saturday: DateComponents(hour: 6, minute: 56)
        ],
        .E09: [
            .sunday: DateComponents(hour: 7, minute: 53),
            .weekday: DateComponents(hour: 4, minute: 53),
            .saturday: DateComponents(hour: 6, minute: 53)
        ],
        .E10: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50)
        ],
        .F01: [
            .sunday: DateComponents(hour: 8, minute: 15),
            .weekday: DateComponents(hour: 5, minute: 15),
            .saturday: DateComponents(hour: 7, minute: 15)
        ],
        .F02: [
            .sunday: DateComponents(hour: 8, minute: 13),
            .weekday: DateComponents(hour: 5, minute: 13),
            .saturday: DateComponents(hour: 7, minute: 13)
        ],
        .F03: [
            .sunday: DateComponents(hour: 8, minute: 9),
            .weekday: DateComponents(hour: 5, minute: 9),
            .saturday: DateComponents(hour: 7, minute: 9)
        ],
        .F04: [
            .sunday: DateComponents(hour: 8, minute: 9),
            .weekday: DateComponents(hour: 5, minute: 9),
            .saturday: DateComponents(hour: 7, minute: 9)
        ],
        .F05: [
            .sunday: DateComponents(hour: 8, minute: 7),
            .weekday: DateComponents(hour: 5, minute: 7),
            .saturday: DateComponents(hour: 7, minute: 7)
        ],
        .F06: [
            .sunday: DateComponents(hour: 8, minute: 4),
            .weekday: DateComponents(hour: 5, minute: 4),
            .saturday: DateComponents(hour: 7, minute: 4)
        ],
        .F07: [
            .sunday: DateComponents(hour: 8, minute: 1),
            .weekday: DateComponents(hour: 5, minute: 1),
            .saturday: DateComponents(hour: 7, minute: 1)
        ],
        .F08: [
            .sunday: DateComponents(hour: 7, minute: 59),
            .weekday: DateComponents(hour: 4, minute: 59),
            .saturday: DateComponents(hour: 6, minute: 59)
        ],
        .F09: [
            .sunday: DateComponents(hour: 7, minute: 56),
            .weekday: DateComponents(hour: 4, minute: 56),
            .saturday: DateComponents(hour: 6, minute: 56)
        ],
        .F10: [
            .sunday: DateComponents(hour: 7, minute: 53),
            .weekday: DateComponents(hour: 4, minute: 53),
            .saturday: DateComponents(hour: 6, minute: 53)
        ],
        .F11: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50)
        ],
        .G01: [
            .sunday: DateComponents(hour: 7, minute: 55),
            .weekday: DateComponents(hour: 4, minute: 55),
            .saturday: DateComponents(hour: 6, minute: 55)
        ],
        .G02: [
            .sunday: DateComponents(hour: 7, minute: 52),
            .weekday: DateComponents(hour: 4, minute: 52),
            .saturday: DateComponents(hour: 6, minute: 52)
        ],
        .G03: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50)
        ],
        .G04: [
            .sunday: DateComponents(hour: 7, minute: 47),
            .weekday: DateComponents(hour: 4, minute: 47),
            .saturday: DateComponents(hour: 6, minute: 47)
        ],
        .G05: [
            .sunday: DateComponents(hour: 7, minute: 44),
            .weekday: DateComponents(hour: 4, minute: 44),
            .saturday: DateComponents(hour: 6, minute: 44)
        ],
        .J02: [
            .sunday: DateComponents(hour: 7, minute: 56),
            .weekday: DateComponents(hour: 4, minute: 56),
            .saturday: DateComponents(hour: 6, minute: 56)
        ],
        .J03: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50)
        ],
        .K01: [
            .sunday: DateComponents(hour: 8, minute: 10),
            .weekday: DateComponents(hour: 5, minute: 10),
            .saturday: DateComponents(hour: 7, minute: 10)
        ],
        .K02: [
            .sunday: DateComponents(hour: 8, minute: 8),
            .weekday: DateComponents(hour: 5, minute: 8),
            .saturday: DateComponents(hour: 7, minute: 8)
        ],
        .K03: [
            .sunday: DateComponents(hour: 8, minute: 7),
            .weekday: DateComponents(hour: 5, minute: 7),
            .saturday: DateComponents(hour: 7, minute: 7)
        ],
        .K04: [
            .sunday: DateComponents(hour: 8, minute: 9),
            .weekday: DateComponents(hour: 5, minute: 9),
            .saturday: DateComponents(hour: 7, minute: 9)
        ],
        .K05: [
            .sunday: DateComponents(hour: 8, minute: 1),
            .weekday: DateComponents(hour: 5, minute: 1),
            .saturday: DateComponents(hour: 7, minute: 1)
        ],
        .K06: [
            .sunday: DateComponents(hour: 7, minute: 58),
            .weekday: DateComponents(hour: 4, minute: 58),
            .saturday: DateComponents(hour: 6, minute: 58)
        ],
        .K07: [
            .sunday: DateComponents(hour: 7, minute: 54),
            .weekday: DateComponents(hour: 4, minute: 54),
            .saturday: DateComponents(hour: 6, minute: 54)
        ],
        .K08: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50)
        ],
        .N01: [
            .sunday: DateComponents(hour: 8, minute: 3),
            .weekday: DateComponents(hour: 5, minute: 3),
            .saturday: DateComponents(hour: 7, minute: 3)
        ],
        .N02: [
            .sunday: DateComponents(hour: 8, minute: 1),
            .weekday: DateComponents(hour: 5, minute: 1),
            .saturday: DateComponents(hour: 7, minute: 1)
        ],
        .N03: [
            .sunday: DateComponents(hour: 7, minute: 59),
            .weekday: DateComponents(hour: 4, minute: 59),
            .saturday: DateComponents(hour: 6, minute: 59)
        ],
        .N04: [
            .sunday: DateComponents(hour: 7, minute: 57),
            .weekday: DateComponents(hour: 4, minute: 57),
            .saturday: DateComponents(hour: 6, minute: 57)
        ],
        .N06: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50)
        ],
    ]
    
}
