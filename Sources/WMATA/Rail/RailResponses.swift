//
//  RailResponses.swift
//
//
//  Created by Emma K Alexandra on 6/16/19.
//

import Foundation

/// Response from the [Next Trains API](https://developer.wmata.com/docs/services/547636a6f9182302184cda78/operations/547636a6f918230da855363f)
/// - Tag: RailPredictions
public struct RailPredictions: Codable {
    /// List of predictions
    public let trains: [RailPrediction]

    /// Create a rail predictions response
    ///
    /// - Parameters:
    ///     - trains: List of rail predictions
    public init(trains: [RailPrediction]) {
        self.trains = trains
    }
}

/// Response from the [Next Trains API](https://developer.wmata.com/docs/services/547636a6f9182302184cda78/operations/547636a6f918230da855363f)
/// - Tag: RailPrediction
public struct RailPrediction: Codable {
    /// Number of cars on a train, usually 6 or 8, but might also return -.
    public let car: String?
    
    /// Abbreviated version of the final destination for a train. This is similar to what is displayed on the signs at stations.
    public let destinationShortName: String
    
    /// Destination station
    public let destination: Station?
    
    /// When DestinationCode is populated, this is the full name of the destination station, as shown on the WMATA website.
    public let destinationName: String
    
    /// Denotes the track this train is on, but does not necessarily equate to Track 1 or Track 2. With the exception of terminal stations, predictions at the same station with different Group values refer to trains on different tracks.
    public let group: String
    
    /// Line of the train
     @MapToNil<Line, Dashes> public var line: Line?
    
    /// The station the train is currently arriving at
    public let location: Station
    
    /// Full name of the station where the train is arriving.
    public let locationName: String
    
    /// Minutes until arrival. Can be a numeric value, ARR (arriving), BRD (boarding), ---, or empty.
    public let minutes: String

    /// Create a rail prediction response
    ///
    /// - Parameters:
    ///     - car: Number of train cars
    ///     - destination: Abbreviated version of destination
    ///     - destinationCode: Destination station
    ///     - destinationName: Full name of destination
    ///     - group: Track the train is on
    ///     - line: Line of train
    ///     - location: Station the train is currently arriving at
    ///     - locationName: Full name of station the train is currently arriving at
    ///     - minutes: Minutes until arrival
    public init(
        car: String?,
        destinationShortName: String,
        destination: Station?,
        destinationName: String,
        group: String,
        line: Line,
        location: Station,
        locationName: String,
        minutes: String
    ) {
        self.car = car
        self.destinationShortName = destinationShortName
        self.destination = destination
        self.destinationName = destinationName
        self.group = group
        self.line = line
        self.location = location
        self.locationName = locationName
        self.minutes = minutes
    }
}

/// Response from the [Live Train Positions API](https://developer.wmata.com/docs/services/5763fa6ff91823096cac1057/operations/5763fb35f91823096cac1058)
/// - Tag: TrainPositions
public struct TrainPositions: Codable {
    /// List of train positions
    public let trainPositions: [TrainPosition]

    /// Create a train positions response
    ///
    /// - Parameters:
    ///     - trainPositions: List of train positions
    public init(trainPositions: [TrainPosition]) {
        self.trainPositions = trainPositions
    }
}

/// Response from the [Live Train Positions API](https://developer.wmata.com/docs/services/5763fa6ff91823096cac1057/operations/5763fb35f91823096cac1058)
/// - Tag: TrainPosition
public struct TrainPosition: Codable {
    /// Uniquely identifiable internal train identifier
    public let trainID: String
    
    /// Non-unique train identifier, often used by WMATA's Rail Scheduling and Operations Teams, as well as over open radio communication.
    public let trainNumber: String
    
    /// Number of cars. Can be 0.
    public let carCount: Int
    
    /// The direction of movement regardless of which track the train is on.
    public let directionNumber: Int
    
    /// The circuit identifier the train is currently on.
    public let circuitID: Int
    
    /// Destination of train
    public let destination: Station?
    
    /// Line the train is on
    public let line: Line?
    
    /// Approximate "dwell time". This is not an exact value, but can be used to determine how long a train has been reported at the same track circuit.
    public let secondsAtLocation: Int
    
    /// Service Type of a train.
    public let serviceType: String

    /// Create a train position response
    ///
    /// - Parameters:
    ///     - trainID: Unique train identifier
    ///     - trainNumber: Non-unique train identifier
    ///     - carCount: Number of cars on train
    ///     - directionNumber: Direction of movement
    ///     - circuitID: Circuit identifier train is currently on
    ///     - destination: Destination of train
    ///     - line: Line the train is currently on
    ///     - secondsAtLocation: Dwell time
    ///     - serviceType: Type of service of train
    public init(
        trainID: String,
        trainNumber: String,
        carCount: Int,
        directionNumber: Int,
        circuitID: Int,
        destination: Station?,
        line: Line?,
        secondsAtLocation: Int,
        serviceType: String
    ) {
        self.trainID = trainID
        self.trainNumber = trainNumber
        self.carCount = carCount
        self.directionNumber = directionNumber
        self.circuitID = circuitID
        self.destination = destination
        self.line = line
        self.secondsAtLocation = secondsAtLocation
        self.serviceType = serviceType
    }
}

/// Response from the [Standard Routes API](https://developer.wmata.com/docs/services/5763fa6ff91823096cac1057/operations/57641afc031f59363c586dca)
/// - Tag: StandardRoutes
public struct StandardRoutes: Codable {
    /// List of standard routes
    public let standardRoutes: [StandardRoute]

    /// Create a standard routes response
    ///
    /// - Parameters:
    ///     - standardRoutes: List of standard routes
    public init(standardRoutes: [StandardRoute]) {
        self.standardRoutes = standardRoutes
    }
}

/// Response from the [Standard Routes API](https://developer.wmata.com/docs/services/5763fa6ff91823096cac1057/operations/57641afc031f59363c586dca)
/// - Tag: StandardRoute
public struct StandardRoute: Codable {
    /// Line of this route
    public let line: Line
    
    /// Track number. 1 or 2.
    public let trackNumber: Int
    
    /// Array containing ordered track circuit information
    public let trackCircuits: [TrackCircuitWithStation]

    /// Create a standard route response
    ///
    /// - Parameters:
    ///     - line: Line of route
    ///     - trackNumber: Track the route is on
    ///     - trackCiruits: Ordered track circuit information
    public init(
        line: Line,
        trackNumber: Int,
        trackCircuits: [TrackCircuitWithStation]
    ) {
        self.line = line
        self.trackNumber = trackNumber
        self.trackCircuits = trackCircuits
    }
}

/// Response from the [Standard Routes API](https://developer.wmata.com/docs/services/5763fa6ff91823096cac1057/operations/57641afc031f59363c586dca)
/// - Tag: TrackCircuitWithStation
public struct TrackCircuitWithStation: Codable {
    /// Order in which the circuit appears for the given line and track.
    public let sequenceNumber: Int
    
    /// An internal system-wide uniquely identifiable circuit number.
    public let circuitID: Int
    
    /// Station this circuit is at, if it is at a station
    public let station: Station?

    /// Create a track circuit with station response
    ///
    /// - Parameters:
    ///     - sequenceNumber: Order the ciruit appears in
    ///     - circuitId: Unique circuit id
    ///     - station: Station the circuit is at, if it's at one
    public init(
        sequenceNumber: Int,
        circuitID: Int,
        station: Station?
    ) {
        self.sequenceNumber = sequenceNumber
        self.circuitID = circuitID
        self.station = station
    }
}

/// Response from the [Track Circuits API](https://developer.wmata.com/docs/services/5763fa6ff91823096cac1057/operations/57644238031f59363c586dcb)
/// - Tag: TrackCircuits
public struct TrackCircuits: Codable {
    /// List of track ciruits
    public let trackCircuits: [TrackCircuit]

    /// Create a track circuits response
    ///
    /// - Parameters:
    ///     - trackCircuits: List of track circuits
    public init(trackCircuits: [TrackCircuit]) {
        self.trackCircuits = trackCircuits
    }
}

/// Response from the [Track Circuits API](https://developer.wmata.com/docs/services/5763fa6ff91823096cac1057/operations/57644238031f59363c586dcb)
/// - Tag: TrackCircuit
public struct TrackCircuit: Codable {
    /// Track number. 1 and 2 denote "main" lines, while 0 and 3 are connectors (between different types of tracks) and pocket tracks, respectively.
    public let track: Int
    
    /// An internal system-wide uniquely identifiable circuit number.
    public let circuitID: Int
    
    /// Array containing track circuit neighbor information. Note that some track circuits have no neighbors in one direction. All track circuits have at least one neighbor.
    public let neighbors: [TrackNeighbor]

    /// Create a track circuit response
    ///
    /// - Parameters:
    ///     - track: Track number
    ///     - circuitId: Unique circuit id
    ///     - neighbors: Track circuit neighbors
    public init(
        track: Int,
        circuitID: Int,
        neighbors: [TrackNeighbor]
    ) {
        self.track = track
        self.circuitID = circuitID
        self.neighbors = neighbors
    }
}

/// Response from the [Track Circuits API](https://developer.wmata.com/docs/services/5763fa6ff91823096cac1057/operations/57644238031f59363c586dcb)
/// - Tag: TrackNeighbor
public struct TrackNeighbor: Codable {
    /// Left or Right neighbor group. Generally speaking, left neighbors are to the west and south, while right neighbors are to the east/north.
    public let neighborType: String
    
    /// Neighboring circuit ids.
    public let circuitIDs: [Int]

    /// Create a track neighbor response
    ///
    /// - Parameters:
    ///     - neighborType: Left or Right neighbor group
    ///     - circuitIds: Neighboring circuits
    public init(
        neighborType: String,
        circuitIDs: [Int]
    ) {
        self.neighborType = neighborType
        self.circuitIDs = circuitIDs
    }
}

/// Response from the [Lines API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330c)
/// - Tag: LinesResponse
public struct LinesResponse: Codable {
    /// List of lines
    public let lines: [LineResponse]

    /// Create lines response
    ///
    /// - Parameters:
    ///     - lines: List of lines
    public init(lines: [LineResponse]) {
        self.lines = lines
    }
}

/// Response from the [Lines API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330c)
/// - Tag: LineResponse
public struct LineResponse: Codable {
    /// The actual line
    public let line: Line
    
    /// Full name of the Line.
    public let displayName: String
    
    /// Station for start of the Line.
    public let startStation: Station
    
    /// Station for end of the Line
    public let endStation: Station
    
    /// Intermediate terminal station. During normal service, some trains on some lines might end their trip prior to the StartStationCode or EndStationCode. A good example is on the Red Line where some trains stop at A11 (Grosvenor) or B08 (Silver Spring).
    @MapToNil<Station, EmptyString> public var firstInternalDestination: Station?
    
    /// Intermediate terminal station. During normal service, some trains on some lines might end their trip prior to the StartStationCode or EndStationCode. A good example is on the Red Line where some trains stop at A11 (Grosvenor) or B08 (Silver Spring).
    @MapToNil<Station, EmptyString> public var secondInternalDestination: Station?

    /// Create a line response
    ///
    /// - Parameters:
    ///     - line: Line code
    ///     - displayName: Name of line
    ///     - startStation: Station at start of Line
    ///     - endStation: Station at end of Line
    ///     - firstInternalDestination: Intermediate terminal station
    ///     - secondInternalDestination: Intermediate terminal station
    public init(
        line: Line,
        displayName: String,
        startStation: Station,
        endStation: Station,
        firstInternalDestination: Station?,
        secondInternalDestination: Station?
    ) {
        self.line = line
        self.displayName = displayName
        self.startStation = startStation
        self.endStation = endStation
        self.firstInternalDestination = firstInternalDestination
        self.secondInternalDestination = secondInternalDestination
    }
}

/// Response from the [Parking Information API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330d)
/// - Tag: StationsParking
public struct StationsParking: Codable {
    /// List of parking information
    public let stationsParking: [StationParking]

    /// Create stations parking response
    ///
    /// - Parameters:
    ///     - stationsParking: List of parking information
    public init(stationsParking: [StationParking]) {
        self.stationsParking = stationsParking
    }
}

/// Response from the [Parking Information API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330d)
/// - Tag: StationParking
public struct StationParking: Codable {
    /// Station this parking info is for
    public let station: Station
    
    /// When not empty, provides additional parking resources such as nearby lots.
    public let notes: String
    
    /// All-day parking options.
    public let allDayParking: AllDayParking
    
    /// Short-term parking options.
    public let shortTermParking: ShortTermParking

    /// Create a station parking response
    ///
    /// - Parameters:
    ///     - station: Station for this parking info
    ///     - notes: Additional parking information
    ///     - allDayParking: All-day parking options
    ///     - shortTermParking: Short term parking options
    public init(
        station: Station,
        notes: String,
        allDayParking: AllDayParking,
        shortTermParking: ShortTermParking
    ) {
        self.station = station
        self.notes = notes
        self.allDayParking = allDayParking
        self.shortTermParking = shortTermParking
    }
}

/// Response from the [Parking Information API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330d)
/// - Tag: AllDayParking
public struct AllDayParking: Codable {
    /// Number of all-day parking spots available at a station.
    public let totalCount: Int
    
    /// All-day cost per day (weekday) for Metro riders.
    public let riderCost: Double
    
    /// All-day cost per day (weekday) for non-Metro riders.
    public let nonRiderCost: Double
    
    /// Similar to RiderCost, except denoting Saturday prices.
    public let saturdayRiderCost: Double
    
    /// Similar to NonRiderCost, except denoting Saturday prices.
    public let saturdayNonRiderCost: Double

    /// Create all day parking response
    ///
    /// - Parameters:
    ///     - totalCount: Number of all day parking spots
    ///     - riderCost: All day weekday costs for Metro riders
    ///     - nonRiderCost: All day weekday cost for non-Metro riders
    ///     - saturdayRiderCost: riderCost, but for Saturdays
    ///     - saturdayNonRiderCost: nonRiderCost, but for Saturdays
    public init(
        totalCount: Int,
        riderCost: Double,
        nonRiderCost: Double,
        saturdayRiderCost: Double,
        saturdayNonRiderCost: Double
    ) {
        self.totalCount = totalCount
        self.riderCost = riderCost
        self.nonRiderCost = nonRiderCost
        self.saturdayRiderCost = saturdayRiderCost
        self.saturdayNonRiderCost = saturdayNonRiderCost
    }
}

/// Response from the [Parking Information API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330d)
/// - Tag: ShortTermParking
public struct ShortTermParking: Codable {
    /// Number of short-term parking spots available at a station (parking meters).
    public let totalCount: Int
    
    /// Misc. information relating to short-term parking.
    public let notes: String

    /// Create a short term parking response
    ///
    /// - Parameters:
    ///     - totalCount: Number of parking meters available at this station
    ///     - notes: Misc. parking information
    public init(
        totalCount: Int,
        notes: String
    ) {
        self.totalCount = totalCount
        self.notes = notes
    }
}

/// Response from the [Path Between Stations API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330e)
/// - Tag: PathBetweenStations
public struct PathBetweenStations: Codable {
    /// List of path information
    public let path: [Path]

    /// Create a path between stations response
    ///
    /// - Parameters:
    ///     - path: List of path information
    public init(path: [Path]) {
        self.path = path
    }
}

/// Response from the [Path Between Stations API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330e)
/// - Tag: Path
public struct Path: Codable {
    /// Distance in feet to the previous station in the list.
    public let distanceToPreviousStation: Int
    
    /// Line of this station
    public let line: Line
    
    /// Order this path appears
    public let sequenceNumber: Int
    
    /// Station code
    public let station: Station
    
    /// Full name for this station, as shown on the WMATA website.
    public let stationName: String

    /// Create a path response
    ///
    /// - Parameters:
    ///     - distanceToPreviousStation: Distance in feet to previous station
    ///     - line: Line of this station
    ///     - sequenceNumber: Order this path appears
    ///     - station: Station code
    ///     - stationName: Full station name
    public init(
        distanceToPreviousStation: Int,
        line: Line,
        sequenceNumber: Int,
        station: Station,
        stationName: String
    ) {
        self.distanceToPreviousStation = distanceToPreviousStation
        self.line = line
        self.sequenceNumber = sequenceNumber
        self.station = station
        self.stationName = stationName
    }
}

/// Response from the [Station Entrances API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330f)
/// - Tag: StationEntrances
public struct StationEntrances: Codable {
    /// List of station entrances
    public let entrances: [StationEntrance]

    /// Create a station entrances response
    ///
    /// - Parameters:
    ///     - entrances: List of station entrances
    public init(entrances: [StationEntrance]) {
        self.entrances = entrances
    }
}

/// Response from the [Station Entrances API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe330f)
/// - Tag: StationEntrance
public struct StationEntrance: Codable {
    /// Additional information for the entrance.
    public let description: String
    
    /// Warning: Deprecated.
    public let id: String
    
    /// Latitude of entrance.
    public let latitude: Double
    
    /// Longitude of entrance.
    public let longitude: Double
    
    /// Name of entrance.
    public let name: String
    
    /// First station for this entrance
    public let firstStation: Station
    
    /// Second station for this entrance. See multilevel stations like L'Enfant Plaza, Metro Center
    @MapToNil<Station, EmptyString> public var secondStation: Station?

    /// Create a station entrance response
    ///
    /// - Parameters:
    ///     - description: Additional entrance information
    ///     - id: Deprecated.
    ///     - latitude: Latitude of entrance
    ///     - longitude: Longitude of entrance
    ///     - name: Name of entrance
    ///     - firstStation: First station of this entrance
    ///     - secondStation: Second station of this entrance. i.e. L'Enfant Plaza
    public init(
        description: String,
        id: String,
        latitude: Double,
        longitude: Double,
        name: String,
        firstStation: Station,
        secondStation: Station?
    ) {
        self.description = description
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.firstStation = firstStation
        self.secondStation = secondStation
    }
}

/// Response from the [Station Information API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3310),
/// Response from the [Station List API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3311)
/// - Tag: StationInformation
public struct StationInformation: Codable {
    /// Address information.
    public let address: StationAddress
    
    /// Station code
    public let station: Station
    
    /// Latitude of this station.
    public let latitude: Double
    
    /// Longitude of this station.
    public let longitude: Double
    
    /// First line of this station
    public let firstLine: Line
    
    /// Second line of this station
    public let secondLine: Line?
    
    /// Third line of this station
    public let thirdLine: Line?
    
    /// Fourth line of this station. Unused.
    public let fourthLine: Line?
    
    /// Name of this station
    public let name: String
    
    /// For stations with multiple platforms (e.g.: Gallery Place, Fort Totten, L'Enfant Plaza, and Metro Center), the additional station will be listed here.
    @MapToNil<Station, EmptyString> public var firstStationTogether: Station?
    
    /// Unused.
    @MapToNil<Station, EmptyString> public var secondStationTogether: Station?

    /// Create a station information response
    ///
    /// - Parameters:
    ///     - address: Address information
    ///     - station: Station code
    ///     - latitude: Latitude of this station
    ///     - longitude: Longitude of this station
    ///     - firstLine: First line of this station
    ///     - secondLine: Second line of this station
    ///     - thirdLine: Third line of this station
    ///     - fourthLine: Fourth line of this station. Unused.
    ///     - name: Name of station
    ///     - firstStationTogether: Additional station for multilevel stations like Fort Totten
    ///     - secondStationTogether: Unused
    public init(
        address: StationAddress,
        station: Station,
        latitude: Double,
        longitude: Double,
        firstLine: Line,
        secondLine: Line?,
        thirdLine: Line?,
        fourthLine: Line?,
        name: String,
        firstStationTogether: Station?,
        secondStationTogether: Station?
    ) {
        self.address = address
        self.station = station
        self.latitude = latitude
        self.longitude = longitude
        self.firstLine = firstLine
        self.secondLine = secondLine
        self.thirdLine = thirdLine
        self.fourthLine = fourthLine
        self.name = name
        self.firstStationTogether = firstStationTogether
        self.secondStationTogether = secondStationTogether
    }
}

/// Response from the [Station Information API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3310)
/// - Tag: StationAddress
public struct StationAddress: Codable {
    /// City of this station.
    public let city: String
    
    /// State of this station.
    public let state: String
    
    /// Street address (for GPS use) of this station.
    public let street: String
    
    /// Zip code of this station.
    public let zip: String

    /// Create station address response
    ///
    /// - Parameters:
    ///     - city: City of this station
    ///     - state: State of this station
    ///     - street: Stress address of this station
    ///     - zip: Zip code of this station
    public init(
        city: String,
        state: String,
        street: String,
        zip: String
    ) {
        self.city = city
        self.state = state
        self.street = street
        self.zip = zip
    }
}

/// Response from the [Station List API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3311)
/// - Tag: Stations
public struct Stations: Codable {
    /// List of station information
    public let stations: [StationInformation]

    /// Create a stations response
    ///
    /// - Parameters:
    ///     - stations: List of station information
    public init(stations: [StationInformation]) {
        self.stations = stations
    }
}

/// Response from the [Station Timings API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3312)
/// - Tag: StationTimings
public struct StationTimings: Codable {
    /// List of station times
    public let stationTimes: [StationTime]

    /// Create a station timings response
    ///
    /// - Parameters:
    ///     - stationTimes: List of station times
    public init(stationTimes: [StationTime]) {
        self.stationTimes = stationTimes
    }
}

/// Response from the [Station Timings API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3312)
/// - Tag: StationTime
public struct StationTime: Codable {
    /// Station code
    public let station: Station
    
    /// Full name of the station.
    public let stationName: String
    
    /// Timing information for Monday
    public let monday: StationFirstLastTrains
    
    /// Timing information for Tuesday
    public let tuesday: StationFirstLastTrains
    
    /// Timing information for Wednesday
    public let wednesday: StationFirstLastTrains
    
    /// Timing information for Thursday
    public let thursday: StationFirstLastTrains
    
    /// Timing information for Friday
    public let friday: StationFirstLastTrains
    
    /// Timing information for Saturday
    public let saturday: StationFirstLastTrains
    
    /// Timing information for Sunday
    public let sunday: StationFirstLastTrains

    /// Create a station time response
    ///
    /// - Parameters:
    ///     - station: Station code
    ///     - stationName: Name of station
    ///     - monday: Timing information for Monday
    ///     - tuesday: Timing information for Tuesday
    ///     - wednesday: Timing information for Wednesday
    ///     - thursday: Timing information for Thursday
    ///     - friday: Timing information for Friday
    ///     - saturday: Timing information for Saturday
    ///     - sunday: Timing information for Sunday
    public init(
        station: Station,
        stationName: String,
        monday: StationFirstLastTrains,
        tuesday: StationFirstLastTrains,
        wednesday: StationFirstLastTrains,
        thursday: StationFirstLastTrains,
        friday: StationFirstLastTrains,
        saturday: StationFirstLastTrains,
        sunday: StationFirstLastTrains
    ) {
        self.station = station
        self.stationName = stationName
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
        self.sunday = sunday
    }
}

/// Response from the [Station Timings API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3312)
/// - Tag: StationFirstLastTrains
public struct StationFirstLastTrains: Codable {
    /// Station opening time. Format is HH:mm.
    public let openingTime: String
    
    /// First train information
    public let firstTrains: [TrainTime]
    
    /// Last train information
    public let lastTrains: [TrainTime]

    /// Create a station first last trains response
    ///
    /// - Parameters:
    ///     - openingTime: Station opening time
    ///     - firstTrains: First train information
    ///     - lastTrains: Last trains information
    public init(
        openingTime: String,
        firstTrains: [TrainTime],
        lastTrains: [TrainTime]
    ) {
        self.openingTime = openingTime
        self.firstTrains = firstTrains
        self.lastTrains = lastTrains
    }
}

/// Response from the [Station Timings API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3312)
/// - Tag: TrainTime
public struct TrainTime: Codable {
    /// Time the train leaves the station. Format is HH:mm.
    public let time: String
    
    /// Train's destination
    public let destination: Station

    /// Create a train time response
    ///
    /// - Parameters:
    ///     - time: Time the train leaves the station
    ///     - destination: Destination station
    public init(time: String, destination: Station) {
        self.time = time
        self.destination = destination
    }
}

/// Response from the [Station to Station Information API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3313)
/// - Tag: StationToStationInfos
public struct StationToStationInfos: Codable {
    /// List of station to station info
    public let stationToStationInfos: [StationToStationInfo]

    /// Create a station to station infos response
    ///
    /// - Parameters:
    ///     - stationToStationInfos: List of station to station information
    public init(stationToStationInfos: [StationToStationInfo]) {
        self.stationToStationInfos = stationToStationInfos
    }
}

/// Response from the [Station to Station Information API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3313)
/// - Tag: StationToStationInfo
public struct StationToStationInfo: Codable {
    /// Average of distance traveled between two stations and straight-line distance (as used for WMATA fare calculations).
    public let compositeMiles: Double
    
    /// Destination station
    public let destination: Station
    
    /// Fare information
    public let railFare: RailFare
    
    /// Estimated travel time (schedule time) in minutes between the source and destination station. This is not correlated to minutes (Min) in Real-Time Rail Predictions.
    public let railTime: Int
    
    /// Origin station
    public let source: Station

    /// Create a station to station info response
    ///
    /// - Parameters:
    ///     - compositeMiles: Average distance travelled between two stations
    ///     - destination: Destination station
    ///     - railFare: Fare information
    ///     - railTime: Estimated travel time in minuites
    ///     - source: Origin station
    public init(
        compositeMiles: Double,
        destination: Station,
        railFare: RailFare,
        railTime: Int,
        source: Station
    ) {
        self.compositeMiles = compositeMiles
        self.destination = destination
        self.railFare = railFare
        self.railTime = railTime
        self.source = source
    }
}

/// Response from the [Station to Station Information API](https://developer.wmata.com/docs/services/5476364f031f590f38092507/operations/5476364f031f5909e4fe3313)
/// - Tag: RailFare
public struct RailFare: Codable {
    /// Fare during off-peak times.
    public let offPeakTime: Double
    
    /// Fare during peak times (weekdays from opening to 9:30 AM and 3-7 PM, and weekends from midnight to closing).
    public let peakTime: Double
    
    /// Reduced fare for senior citizens or people with disabilities.
    public let seniorDisabled: Double

    /// Create a rail fare response
    ///
    /// - Parameters:
    ///     - offPeakTime: Off-peak fare
    ///     - peakTime: Peak fare
    ///     - seniorDisabled: Reduced fare
    public init(
        offPeakTime: Double,
        peakTime: Double,
        seniorDisabled: Double
    ) {
        self.offPeakTime = offPeakTime
        self.peakTime = peakTime
        self.seniorDisabled = seniorDisabled
    }
}

/// Response from the [Elevator and Escalator Incidents API](https://developer.wmata.com/docs/services/54763641281d83086473f232/operations/54763641281d830c946a3d76)
/// - Tag: ElevatorAndEscalatorIncidents
public struct ElevatorAndEscalatorIncidents: Codable {
    /// List of elevator and escalator incidents
    public let incidents: [ElevatorOrEscalatorIncident]

    /// Create an elevator and escalator incidents response
    ///
    /// - Parameters:
    ///     - incidents: List of elevator and escalator incidents
    public init(incidents: [ElevatorOrEscalatorIncident]) {
        self.incidents = incidents
    }
}

/// Response from the [Elevator and Escalator Incidents API](https://developer.wmata.com/docs/services/54763641281d83086473f232/operations/54763641281d830c946a3d76)
/// - Tag: ElevatorAndEscalatorIncident
public struct ElevatorOrEscalatorIncident: Codable {
    /// Unique identifier for unit, by type (a single elevator and escalator may have the same UnitName, but no two elevators or two escalators will have the same UnitName).
    public let unitName: String
    
    /// Type of unit. Will be ELEVATOR or ESCALATOR.
    public let unitType: String
    
    /// Warning: Deprecated. If listed here, the unit is inoperational or otherwise impaired.
    public let unitStatus: String?
    
    /// Station of the incident
    public let station: Station
    
    /// Full station name, may include entrance information (e.g.: Metro Center, G and 11th St Entrance).
    public let stationName: String
    
    /// Free-text description of the unit location within a station (e.g.: Escalator between mezzanine and platform).
    public let locationDescription: String
    
    /// Warning: Deprecated.
    public let symptomCode: String?
    
    /// Warning: Deprecated. Use the time portion of the DateOutOfServ element.
    public let timeOutOfService: String
    
    /// Description for why the unit is out of service or otherwise in reduced operation.
    public let symptomDescription: String
    
    /// Warning: Deprecated.
    public let displayOrder: Double
    
    /// Date and time (Eastern Standard Time) unit was reported out of service.
    public let dateOutOfService: Date
    
    /// Date and time (Eastern Standard Time) outage details was last updated.
    public let dateUpdated: String
    
    /// Estimated date and time (Eastern Standard Time) by when unit is expected to return to normal service.
    public let estimatedReturnToService: String

    /// Create a elevator and escalator incident response
    ///
    /// - Parameters:
    ///     - unitName: id for unit
    ///     - unitType: Type of unit. ELEVATOR or ESCALATOR
    ///     - unitStatus: Deprecated.
    ///     - station: Station of incident
    ///     - stationName: Full name of station, including entrance information
    ///     - locationDescription: Location of unit within station
    ///     - symptomCode: Deprecated.
    ///     - timeOutOfService: Deprecated.
    ///     - symptomDescription: Why the unit is out of service
    ///     - displayOrder: Deprecated.
    ///     - dateOutOfService: Time unit reported out of service
    ///     - dateUpdated: Time outage details were last updated
    ///     - estimatedReturnToService: Time unit is expected to return to normal service
    public init(
        unitName: String,
        unitType: String,
        unitStatus: String?,
        station: Station,
        stationName: String,
        locationDescription: String,
        symptomCode: String?,
        timeOutOfService: String,
        symptomDescription: String,
        displayOrder: Double,
        dateOutOfService: Date,
        dateUpdated: String,
        estimatedReturnToService: String
    ) {
        self.unitName = unitName
        self.unitType = unitType
        self.unitStatus = unitStatus
        self.station = station
        self.stationName = stationName
        self.locationDescription = locationDescription
        self.symptomCode = symptomCode
        self.timeOutOfService = timeOutOfService
        self.symptomDescription = symptomDescription
        self.displayOrder = displayOrder
        self.dateOutOfService = dateOutOfService
        self.dateUpdated = dateUpdated
        self.estimatedReturnToService = estimatedReturnToService
    }
}

/// Response from the [Rail Incidents API](https://developer.wmata.com/docs/services/54763641281d83086473f232/operations/54763641281d830c946a3d77)
/// - Tag: RailIncidents
public struct RailIncidents: Codable {
    /// List of rail incidents
    public let incidents: [RailIncident]

    /// Create a rail incidents response
    ///
    /// - Parameters:
    ///     - incidents: List of rail incidents
    public init(incidents: [RailIncident]) {
        self.incidents = incidents
    }
}

/// Response from the [Rail Incidents API](https://developer.wmata.com/docs/services/54763641281d83086473f232/operations/54763641281d830c946a3d77)
/// - Tag: RailIncident
public struct RailIncident: Codable {
    /// Unique identifier for an incident.
    public let incidentID: String
    
    /// Free-text description of the incident.
    public let description: String
    
    /// Warning: Deprecated.
    public let startLocationFullName: String?
    
    /// Warning: Deprecated.
    public let endLocationFullName: String?
    
    /// Warning: Deprecated.
    public let passengerDelay: Double
    
    /// Warning: Deprecated.
    public let delaySeverity: String?
    
    /// Free-text description of the incident type. Usually Delay or Alert but is subject to change at any time.
    public let incidentType: String
    
    /// Warning: Deprecated.
    public let emergencyText: String?
    
    /// Semi-colon and space separated list of line codes (e.g.: RD; or BL; OR; or BL; OR; RD;). =(
    public let linesAffected: String
    
    /// Date and time (Eastern Standard Time) of last update.
    public let dateUpdated: Date

    /// Create a rail incident response
    ///
    /// - Parameters:
    ///     - incidentID: Unique ID for incident
    ///     - description: Description of incident
    ///     - startLocationFullName: Deprecated.
    ///     - endLocationFullName: Deprecated.
    ///     - passengerDelay: Deprecated.
    ///     - delaySeverity: Deprecated.
    ///     - incidentType: Type of incident
    ///     - emergencyText: Deprecated.
    ///     - linesAffected: Semi-colon and space separated list of line codes. (e.g.: RD; or BL; OR; or BL; OR; RD;). =(
    ///     - dateUpdated: TIme of last status update
    public init(
        incidentID: String,
        description: String,
        startLocationFullName: String?,
        endLocationFullName: String?,
        passengerDelay: Double,
        delaySeverity: String?,
        incidentType: String,
        emergencyText: String?,
        linesAffected: String,
        dateUpdated: Date
    ) {
        self.incidentID = incidentID
        self.description = description
        self.startLocationFullName = startLocationFullName
        self.endLocationFullName = endLocationFullName
        self.passengerDelay = passengerDelay
        self.delaySeverity = delaySeverity
        self.incidentType = incidentType
        self.emergencyText = emergencyText
        self.linesAffected = linesAffected
        self.dateUpdated = dateUpdated
    }
}

@propertyWrapper
public struct MapToNil<Wrapped, MappedValue>: Codable
    where
        Wrapped: Codable & RawRepresentable,
        Wrapped.RawValue == String,
        MappedValue: WMATAMappedValue
    {
    public var wrappedValue: Wrapped?
    
    public init(wrappedValue: Wrapped?) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String?.self)
        
        guard let stringValue = stringValue, stringValue != MappedValue.value else {
            wrappedValue = nil
            return
        }
        
        wrappedValue = Wrapped(rawValue: stringValue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try container.encode(wrappedValue)
    }
}

public protocol WMATAMappedValue {
    static var value: String { get }
}

public struct EmptyString: WMATAMappedValue {
    public static let value = ""
}

public struct Dashes: WMATAMappedValue {
    public static let value = "--"
}
