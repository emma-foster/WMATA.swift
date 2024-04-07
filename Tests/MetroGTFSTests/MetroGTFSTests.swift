//
//  GTFSTests.swift
//  
//
//  Created by Emma on 11/25/23.
//

import XCTest
@testable import MetroGTFS
import WMATA

final class MetroGTFSTests: XCTestCase {
    func testCreateAllStops() throws {
        let database = try GTFSDatabase()
        
        for row in try database.all(GTFSStop.self) {
            let stop = try GTFSStop(row: row)
            
            // Does the Stop ID from the database match one of the valid location type prefixes?
            let prefix = stop.id.rawValue.prefixMatch(of: try Regex("^(ENT|NODE|PF|PLF|STN)"))
            
            XCTAssertNotNil(prefix)
            XCTAssertGreaterThan(prefix!.count, 0)
        }
    }
    
    func testCreateAStop() throws {
        let stop = try GTFSStop(id: .init("STN_N12"))
        
        XCTAssertEqual(stop.name, "ASHBURN METRORAIL STATION")
    }
    
    func testCreateAStopWithShorthand() throws {
        let stop = try GTFSStop("STN_N12")
        
        XCTAssertEqual(stop.name, "ASHBURN METRORAIL STATION")
    }
    
    func testCreateAnInvalidStop() {
        XCTAssertNil(try? GTFSStop("ABCDEFG"))
    }
    
    func testCreateAStopFromWMATAStation() throws {
        let stop = try GTFSStop(station: .ashburn)
        
        XCTAssertEqual(stop.name, "ASHBURN METRORAIL STATION")
    }
    
    func testCreateAllStopsWithParentStation() throws {
        let stops = try GTFSStop.all(withParentStation: .init("STN_B01_F01"))
        
        for stop in stops {
            XCTAssert(stop.name.contains("CHINATOWN") || stop.name.contains("GALLERY PL"), stop.name)
        }
    }
    
    func testCreateAllLevels() throws {
        let database = try GTFSDatabase()
        
        for row in try database.all(GTFSLevel.self) {
            let level = try GTFSLevel(row: row)
            
            let stationCode = level.id.rawValue.prefix(3)
            
            XCTAssertNotNil(Station(rawValue: String(stationCode)))
        }
    }
    
    func testCreateALevel() throws {
        let level = try GTFSLevel(id: .init("B05_L1"))
        
        XCTAssertEqual(level.name, "Mezzanine")
    }
    
    func testCreateALevelWithShorthand() throws {
        let level = try GTFSLevel("B05_L1")
        
        XCTAssertEqual(level.name, "Mezzanine")
    }
    
    func testCreateAnInvalidLevel() throws {
        XCTAssertNil(try? GTFSLevel("ABCDEFG"))
    }
    
    func testCreateAllAgencies() throws {
        let database = try GTFSDatabase()
        
        for row in try database.all(GTFSAgency.self) {
            let agency = try GTFSAgency(row: row)
            
            XCTAssertEqual(agency.name, "WMATA") // there's only one agency in WMATA's data
        }
    }
    
    func testCreateAnAgency() throws {
        let agency = try GTFSAgency(id: .init("1"))
        
        XCTAssertEqual(agency.url, URL(string: "http://www.wmata.com"))
    }
    
    func testCreateAnAgencyWithShorthand() throws {
        let agency = try GTFSAgency("1")
        
        XCTAssertEqual(agency.phone, "202-637-7000")
    }
    
    func testCreateAnInvalidAgency() {
        XCTAssertNil(try? GTFSAgency("WMATA"))
    }
    
    func testCreateFeedInfo() throws {
        let feedInfo = try GTFSFeedInfo(.init("WMATA"))
        
        XCTAssertEqual(feedInfo.publisherName, "WMATA")
        XCTAssertEqual(feedInfo.publisherURL, URL(string: "http://www.wmata.com"))
        XCTAssertTrue(feedInfo.startDate! > Date.distantPast)
    }
    
    func testCreateFeedInfoWithShorthand() throws {
        let feedInfo = try GTFSFeedInfo("WMATA")
        
        XCTAssertEqual(feedInfo.publisherName, "WMATA")
    }
    
    func testCreateInvalidFeedInfo() {
        XCTAssertNil(try? GTFSFeedInfo("ABCDEFG"))
    }
    
    func testCreateAllRoutes() throws {
        for route in try GTFSRoute.all() {
            XCTAssertEqual(route.networkID, .init("Metrorail"))
        }
    }
    
    func testCreateRoute() throws {
        let route = try GTFSRoute(id: .init("RED"))
        
        XCTAssertEqual(route.routeType, .metro)
    }
    
    func testCreateRouteWithShorthand() throws {
        let route = try GTFSRoute("SILVER")
        
        XCTAssertEqual(route.longLame, "Metrorail Silver Line")
    }
    
    func testCreateInvalidRoute() {
        XCTAssertNil(try? GTFSRoute("PURPLE"))
    }
    
    func testCreateRouteFromWMATALine() throws {
        let route = try GTFSRoute(line: .red)
        
        XCTAssertEqual(route.longLame, "Metrorail Red Line")
    }
    
    func testCreateNetwork() {
        let network = GTFSNetwork(id: .init("Metrorail"), name: "Hello")
        
        XCTAssertEqual(network.id, .init("Metrorail"))
        XCTAssertEqual(network.name, "Hello")
    }
    
    func testCreateAllServices() throws {
        for service in try GTFSService.all() {
            XCTAssertGreaterThan(service.all.count, 1)
        }
    }
    
    func testCreateService() throws {
        let service = try GTFSService("weekday_service_R")
        
        XCTAssertEqual(service.thursday, .hasService)
    }
    
    func testCreateInvalidService() {
        XCTAssertNil(try? GTFSService("ABCDEFG"))
    }
    
    func testServiceAll() throws {
        let service = try GTFSService("weekday_service_R")
        
        XCTAssertEqual(service.all.count, 7)
        XCTAssertEqual(service.all[.monday], .hasService)
    }
    
    func testServiceOn() throws {
        let service = try GTFSService("weekend_service_R")
        
        XCTAssertEqual(service.on(.saturday), .hasService)
        XCTAssertEqual(service.on(.monday), .noService)
    }
    
    func testCreateAllServiceChanges() throws {
        for serviceChange in try GTFSServiceChange.all() {
            print(serviceChange)
        }
    }
    
    func testCreateServiceChange() throws {
        let serviceChange = try GTFSServiceChange(serviceID: .init("64_R"), date: Date(from8CharacterNumber: 20240627)!)
        
        XCTAssertEqual(serviceChange.change, .added)
    }
    
    func testCreateInvalidServiceChange() {
        XCTAssertNil(try? GTFSServiceChange(serviceID: .init("ABCDEF"), date: 20240627))
    }
    
    func testCreateServiceChangeWithShorthand() throws {
        let serviceChange = try GTFSServiceChange("64_R", date: 20240627)
        
        XCTAssertEqual(serviceChange.change, .added)
    }
    
    func testCreateAllAreas() throws {
        for area in try GTFSArea.all() {
            XCTAssertTrue(area.id.rawValue == "everywhere" || area.station != nil)
        }
    }
    
    func testCreateArea() throws {
        let area = try GTFSArea("STN_A01_C01")
        
        XCTAssertEqual(area.station, .transfer(.metroCenterUpper, .metroCenterLower))
    }
    
    func testCreateInvalidArea() {
        XCTAssertNil(try? GTFSArea("ABCDEFG"))
    }
    
    func testAreaFromStation() throws {
        let area = try GTFSArea(station: .addisonRoad)
        
        XCTAssertEqual(area.id.rawValue, "STN_G03")
    }
    
    func testAreaFromTransferStation() throws {
        let area = try GTFSArea(station: .metroCenterLower)
        
        XCTAssertEqual(area.id.rawValue, "STN_A01_C01")
    }
    
    func testAllTimeframes() throws {
        for timeframe in try GTFSTimeframe.all() {
            XCTAssertTrue(timeframe.id.rawValue.contains("weekday") || timeframe.id.rawValue.contains("weekend"))
        }
    }
    
    func testCreateTimeframe() throws {
        let timeframe = try GTFSTimeframe("weekday_regular")
                
        XCTAssertEqual(timeframe.serviceID, .init("weekday_service_R"))
    }
    
    func testCreateInvalidTimeframe() {
        XCTAssertNil(try? GTFSTimeframe("ABCDEFG"))
    }

    
    func testCreateAllFareMedia() throws {
        for fareMedia in try GTFSFareMedia.all() {
            XCTAssertEqual(fareMedia.name, "Smartrip")
            XCTAssertTrue([GTFSFareMedia.FareMediaType.physicalTransitCard, GTFSFareMedia.FareMediaType.mobileApp].contains { $0 == fareMedia.mediaType })
        }
    }
    
    func testCreateFareMedia() throws {
        let fareMedia = try GTFSFareMedia("smartrip_app")
        
        XCTAssertEqual(fareMedia.mediaType, .mobileApp)
    }
    
    func testCreateInvalidFareMedia() {
        XCTAssertNil(try? GTFSFareMedia("ABCDEFFG"))
    }
    
    func testCreateAllFareProducts() throws {
        for fareProduct in try GTFSFareProduct.all() {
            XCTAssertGreaterThanOrEqual(fareProduct.amount, 2.00)
        }
    }
    
    func testCreateFareProduct() throws {
        let fareProduct = try GTFSFareProduct("1_day_unlimited_Pass")
        
        XCTAssertGreaterThanOrEqual(fareProduct.amount, 13.00)
        XCTAssertEqual(fareProduct.currency, "USD")
        XCTAssertEqual(fareProduct.name, "1 Day Unlimited Pass")
        XCTAssertEqual(fareProduct.fareMediaID, .init("smartrip_card"))
    }
    
    func testCreateInvalidFareProduct() {
        XCTAssertNil(try? GTFSFareProduct("ABCDEFG"))
    }
    
    func testCreateAllFareLegRule() throws {
        for fareLegRule in try GTFSFareLegRule.all() {
            XCTAssertEqual(fareLegRule.networkID.rawValue, "Metrorail")
        }
    }
    
    func testCreateFareLegRule() throws {
        let fareLegRule = try GTFSFareLegRule(
            fromAreaID: .init("everywhere"),
            toAreaID: .init("everywhere"),
            fromService: .init("weekday_flat")
        )
        
        XCTAssertEqual(fareLegRule.fareProduct, .init("200_flat"))
    }
    
    func testCreateFareLegRuleShorthand() throws {
        let fareLegRule = try GTFSFareLegRule(
            fromAreaID: "STN_A01_C01",
            toAreaID: "STN_A03",
            fromService: "weekday_regular"
        )
        
        XCTAssertEqual(fareLegRule.fareProduct, .init("200_regular"))
        XCTAssertEqual(fareLegRule.networkID, .init("Metrorail"))
    }
    
    func testCreateInvalidFareLegRule() {
        XCTAssertNil(
            try? GTFSFareLegRule(
                networkID: .init("ABCDEFG")
            )
        )
    }
    
    func testCreateAllStopAreas() throws {
        for stopArea in try GTFSStopArea.all() {
            XCTAssertTrue(stopArea.areaID.rawValue.hasPrefix("everywhere") || stopArea.areaID.rawValue.hasPrefix("STN_"))
            XCTAssertTrue(stopArea.stopID.rawValue.hasPrefix("STN_"))
        }
    }
    
    func testCreateStopArea() throws {
        let stopArea = try GTFSStopArea(.init("STN_A03"), stopID: .init("STN_A03"))
        
        XCTAssertEqual(stopArea.areaID, .init("STN_A03"))
    }
    
    func testCreateStopAreaWithShorthand() throws {
        let stopArea = try GTFSStopArea("STN_A03", stopID: "STN_A03")
        
        XCTAssertEqual(stopArea.areaID, .init("STN_A03"))
    }
    
    func testCreateInvalidStopArea() {
        XCTAssertNil(try? GTFSStopArea(.init("STN_A03"), stopID: .init("ABCDEFG")))
    }
    
    func testCreateAllStopAreasForAreaID() throws {
        let stopAreas = try GTFSStopArea.all(areaID: .init("everywhere"))
        
        XCTAssertGreaterThanOrEqual(stopAreas.count, 98)
    }
    
    func testCreateAllStopAreasForStopID() throws {
        let stopAreas = try GTFSStopArea.all(stopID: .init("STN_N04"))
        
        XCTAssertGreaterThanOrEqual(stopAreas.count, 2)
    }
    
    func testCreateAllTrips() throws {
        let allRoutes = try GTFSRoute.all().map { $0.id }
        
        for trip in try GTFSTrip.all() {
            XCTAssertTrue(allRoutes.contains(trip.routeID))
        }
    }
    
    func testCreateTrip() throws {
        let trip = try GTFSTrip(id: .init("5570306_19799"))
        
        XCTAssertEqual(trip.routeID, .init("RED"))
        XCTAssertEqual(trip.serviceID, .init("61_R"))
        XCTAssertEqual(trip.headsign, "GLENMONT")
        XCTAssertEqual(trip.direction, .oneDirection)
        XCTAssertEqual(trip.block, nil)
        XCTAssertEqual(trip.shapeID, .init("RRED_1"))
    }
    
    func testCreateInvalidTrip() {
        XCTAssertNil(try? GTFSTrip(id: .init("ABCDEFG")))
    }
    
    func testCreateTripWithShorthand() throws {
        let trip = try GTFSTrip("5570306_19799")
        
        XCTAssertEqual(trip.headsign, "GLENMONT")
    }
    
    func testCreateAllShapes() throws {
        for shape in try GTFSShape.all() {
            XCTAssertGreaterThanOrEqual(shape.distanceTraveled.value, 0)
        }
    }
    
    func testCreateShape() throws {
        let shape = try GTFSShape(id: .init("RRED_1"), pointSequence: 2)
        
        XCTAssertEqual(shape.id, .init("RRED_1"))
        XCTAssertEqual(shape.latitude, .init(value: 39.120001, unit: .degrees))
        XCTAssertEqual(shape.longitude, .init(value: -77.164740, unit: .degrees))
        XCTAssertEqual(shape.pointSequence, 2)
        XCTAssertEqual(shape.distanceTraveled, .init(value: 0.0013, unit: .miles))
    }
    
    func testCreateShapeWithShorthand() throws {
        let shape = try GTFSShape("RRED_1", pointSequence: 2)
        
        XCTAssertEqual(shape.distanceTraveled, .init(value: 0.0013, unit: .miles))
    }
    
    func testCreateInvalidShape() {
        XCTAssertNil(try? GTFSShape("ABCDEFG", pointSequence: 1))
    }
    
    func testCreateEntireShape() throws {
        let shape = try GTFSShape.entireShape("RRED_1")
        
        XCTAssertEqual(shape.last?.distanceTraveled.value, 32.3763)
    }
    
    func testCreateAllPathways() throws {
        for pathway in try GTFSPathway.all() {
            XCTAssertGreaterThan(pathway.length.value, 0)
        }
    }
    
    func testCreatePathway() throws {
        let pathway = try GTFSPathway(id: .init("C05_134128"))
        
        XCTAssertEqual(pathway.fromStopID, .init("NODE_C05_M_ESC_BT"))
        XCTAssertEqual(pathway.toStopID, .init("NODE_C05_ESC1_TP"))
        XCTAssertEqual(pathway.mode, .walkway)
        XCTAssertEqual(pathway.isBidirectional, .bidirectional)
        XCTAssertEqual(pathway.length, .init(value: 159.8745823, unit: .meters))
        XCTAssertEqual(pathway.transversalTime, .init(value: 35.0, unit: .seconds))
        XCTAssertEqual(pathway.signpostedAs, "OR Vienna/BL Franconia/Springfield/SV Wiehle-Reston East")
    }
    
    func testCreatePathwayWithShorthand() throws {
        let pathway = try GTFSPathway("C05_134128")

        XCTAssertEqual(pathway.signpostedAs, "OR Vienna/BL Franconia/Springfield/SV Wiehle-Reston East")
    }
    
    func testCreateInvalidPathway() {
        XCTAssertNil(try? GTFSPathway("ABCDEFG"))
    }
}
