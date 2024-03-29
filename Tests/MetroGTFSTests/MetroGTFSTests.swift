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
}
