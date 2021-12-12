//
//  Station+OpeningTimes.swift
//  
//
//  Created by Emma on 11/6/21.
//

import Foundation

enum WMATADay {
    case weekday
    case saturday
    case sunday
}

extension Date {
    func wmataDay() -> WMATADay {
        let weekday = Calendar(identifier: .gregorian).component(.weekday, from: self)
        
        switch weekday {
        case 1:
            return .sunday
        case 2...6:
            return .weekday
        default:
            return .saturday
        }
    }
}

extension Station {
    static var openingTimes: [Station: [WMATADay: DateComponents]] = [
        .metroCenterUpper: [
            .sunday: DateComponents(hour: 8, minute: 14),
            .weekday: DateComponents(hour: 5, minute: 14),
            .saturday: DateComponents(hour: 7, minute: 14),
        ],
        .farragutNorth: [
            .sunday: DateComponents(hour: 8, minute: 24),
            .weekday: DateComponents(hour: 5, minute: 24),
            .saturday: DateComponents(hour: 7, minute: 24),
        ],
        .dupontCircle: [
            .sunday: DateComponents(hour: 8, minute: 23),
            .weekday: DateComponents(hour: 5, minute: 23),
            .saturday: DateComponents(hour: 7, minute: 23),
        ],
        .woodleyPark: [
            .sunday: DateComponents(hour: 8, minute: 21),
            .weekday: DateComponents(hour: 5, minute: 21),
            .saturday: DateComponents(hour: 7, minute: 21),
        ],
        .clevelandPark: [
            .sunday: DateComponents(hour: 8, minute: 19),
            .weekday: DateComponents(hour: 5, minute: 19),
            .saturday: DateComponents(hour: 7, minute: 19),
        ],
        .vanNess: [
            .sunday: DateComponents(hour: 8, minute: 17),
            .weekday: DateComponents(hour: 5, minute: 17),
            .saturday: DateComponents(hour: 7, minute: 17),
        ],
        .tenleytown: [
            .sunday: DateComponents(hour: 8, minute: 14),
            .weekday: DateComponents(hour: 5, minute: 14),
            .saturday: DateComponents(hour: 7, minute: 14),
        ],
        .friendshipHeights: [
            .sunday: DateComponents(hour: 8, minute: 12),
            .weekday: DateComponents(hour: 5, minute: 12),
            .saturday: DateComponents(hour: 7, minute: 12),
        ],
        .bethesda: [
            .sunday: DateComponents(hour: 8, minute: 9),
            .weekday: DateComponents(hour: 5, minute: 9),
            .saturday: DateComponents(hour: 7, minute: 9),
        ],
        .medicalCenter: [
            .sunday: DateComponents(hour: 8, minute: 6),
            .weekday: DateComponents(hour: 5, minute: 6),
            .saturday: DateComponents(hour: 7, minute: 6),
        ],
        .grosvenor: [
            .sunday: DateComponents(hour: 8, minute: 3),
            .weekday: DateComponents(hour: 5, minute: 3),
            .saturday: DateComponents(hour: 7, minute: 3),
        ],
        .northBethesda: [
            .sunday: DateComponents(hour: 8, minute: 0),
            .weekday: DateComponents(hour: 5, minute: 0),
            .saturday: DateComponents(hour: 7, minute: 0),
        ],
        .twinbrook: [
            .sunday: DateComponents(hour: 7, minute: 57),
            .weekday: DateComponents(hour: 4, minute: 57),
            .saturday: DateComponents(hour: 6, minute: 57),
        ],
        .rockville: [
            .sunday: DateComponents(hour: 7, minute: 54),
            .weekday: DateComponents(hour: 4, minute: 54),
            .saturday: DateComponents(hour: 6, minute: 54),
        ],
        .shadyGrove: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50),
        ],
        .galleryPlaceUpper: [
            .sunday: DateComponents(hour: 8, minute: 15),
            .weekday: DateComponents(hour: 5, minute: 15),
            .saturday: DateComponents(hour: 7, minute: 15),
        ],
        .judiciarySquare: [
            .sunday: DateComponents(hour: 8, minute: 17),
            .weekday: DateComponents(hour: 5, minute: 17),
            .saturday: DateComponents(hour: 7, minute: 17),
        ],
        .unionStation: [
            .sunday: DateComponents(hour: 8, minute: 15),
            .weekday: DateComponents(hour: 5, minute: 15),
            .saturday: DateComponents(hour: 7, minute: 15),
        ],
        .rhodeIslandAve: [
            .sunday: DateComponents(hour: 8, minute: 11),
            .weekday: DateComponents(hour: 5, minute: 11),
            .saturday: DateComponents(hour: 7, minute: 11),
        ],
        .brookland: [
            .sunday: DateComponents(hour: 8, minute: 8),
            .weekday: DateComponents(hour: 5, minute: 8),
            .saturday: DateComponents(hour: 7, minute: 8),
        ],
        .fortTottenUpper: [
            .sunday: DateComponents(hour: 8, minute: 0),
            .weekday: DateComponents(hour: 5, minute: 0),
            .saturday: DateComponents(hour: 7, minute: 0),
        ],
        .takoma: [
            .sunday: DateComponents(hour: 8, minute: 2),
            .weekday: DateComponents(hour: 5, minute: 2),
            .saturday: DateComponents(hour: 7, minute: 2),
        ],
        .silverSpring: [
            .sunday: DateComponents(hour: 7, minute: 59),
            .weekday: DateComponents(hour: 4, minute: 59),
            .saturday: DateComponents(hour: 6, minute: 59),
        ],
        .forestGlen: [
            .sunday: DateComponents(hour: 7, minute: 56),
            .weekday: DateComponents(hour: 4, minute: 56),
            .saturday: DateComponents(hour: 6, minute: 56),
        ],
        .wheaton: [
            .sunday: DateComponents(hour: 7, minute: 53),
            .weekday: DateComponents(hour: 4, minute: 53),
            .saturday: DateComponents(hour: 6, minute: 53),
        ],
        .glenmont: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50),
        ],
        .noma: [
            .sunday: DateComponents(hour: 8, minute: 13),
            .weekday: DateComponents(hour: 5, minute: 13),
            .saturday: DateComponents(hour: 7, minute: 13),
        ],
        .metroCenterLower: [
            .sunday: DateComponents(hour: 8, minute: 14),
            .weekday: DateComponents(hour: 5, minute: 14),
            .saturday: DateComponents(hour: 7, minute: 14),
        ],
        .mcphersonSquare: [
            .sunday: DateComponents(hour: 8, minute: 16),
            .weekday: DateComponents(hour: 5, minute: 16),
            .saturday: DateComponents(hour: 7, minute: 16),
        ],
        .farragutWest: [
            .sunday: DateComponents(hour: 8, minute: 18),
            .weekday: DateComponents(hour: 5, minute: 18),
            .saturday: DateComponents(hour: 7, minute: 18),
        ],
        .foggyBottom: [
            .sunday: DateComponents(hour: 8, minute: 16),
            .weekday: DateComponents(hour: 5, minute: 16),
            .saturday: DateComponents(hour: 7, minute: 16),
        ],
        .rosslyn: [
            .sunday: DateComponents(hour: 8, minute: 17),
            .weekday: DateComponents(hour: 5, minute: 17),
            .saturday: DateComponents(hour: 7, minute: 17),
        ],
        .arlingtonCemetery: [
            .sunday: DateComponents(hour: 8, minute: 17),
            .weekday: DateComponents(hour: 5, minute: 17),
            .saturday: DateComponents(hour: 7, minute: 17),
        ],
        .pentagon: [
            .sunday: DateComponents(hour: 8, minute: 7),
            .weekday: DateComponents(hour: 5, minute: 7),
            .saturday: DateComponents(hour: 7, minute: 7),
        ],
        .pentagonCity: [
            .sunday: DateComponents(hour: 8, minute: 5),
            .weekday: DateComponents(hour: 5, minute: 5),
            .saturday: DateComponents(hour: 7, minute: 5),
        ],
        .crystalCity: [
            .sunday: DateComponents(hour: 8, minute: 3),
            .weekday: DateComponents(hour: 5, minute: 3),
            .saturday: DateComponents(hour: 7, minute: 3),
        ],
        .ronaldReaganWashingtonNationalAirport: [
            .sunday: DateComponents(hour: 8, minute: 1),
            .weekday: DateComponents(hour: 5, minute: 1),
            .saturday: DateComponents(hour: 7, minute: 1),
        ],
        .braddockRoad: [
            .sunday: DateComponents(hour: 7, minute: 56),
            .weekday: DateComponents(hour: 4, minute: 56),
            .saturday: DateComponents(hour: 6, minute: 56),
        ],
        .kingSt: [
            .sunday: DateComponents(hour: 7, minute: 54),
            .weekday: DateComponents(hour: 4, minute: 54),
            .saturday: DateComponents(hour: 6, minute: 54),
        ],
        .eisenhowerAvenue: [
            .sunday: DateComponents(hour: 7, minute: 52),
            .weekday: DateComponents(hour: 4, minute: 52),
            .saturday: DateComponents(hour: 6, minute: 52),
        ],
        .huntington: [
            .sunday: DateComponents(hour: 8, minute: 50),
            .weekday: DateComponents(hour: 5, minute: 50),
            .saturday: DateComponents(hour: 7, minute: 50),
        ],
        .federalTriangle: [
            .sunday: DateComponents(hour: 8, minute: 13),
            .weekday: DateComponents(hour: 5, minute: 13),
            .saturday: DateComponents(hour: 7, minute: 13),
        ],
        .smithsonian: [
            .sunday: DateComponents(hour: 8, minute: 11),
            .weekday: DateComponents(hour: 5, minute: 11),
            .saturday: DateComponents(hour: 7, minute: 11),
        ],
        .lenfantPlazaLower: [
            .sunday: DateComponents(hour: 8, minute: 9),
            .weekday: DateComponents(hour: 5, minute: 9),
            .saturday: DateComponents(hour: 7, minute: 9),
        ],
        .federalCenterSW: [
            .sunday: DateComponents(hour: 8, minute: 7),
            .weekday: DateComponents(hour: 5, minute: 7),
            .saturday: DateComponents(hour: 7, minute: 7),
        ],
        .capitolSouth: [
            .sunday: DateComponents(hour: 8, minute: 5),
            .weekday: DateComponents(hour: 5, minute: 5),
            .saturday: DateComponents(hour: 7, minute: 5),
        ],
        .easternMarket: [
            .sunday: DateComponents(hour: 8, minute: 3),
            .weekday: DateComponents(hour: 5, minute: 3),
            .saturday: DateComponents(hour: 7, minute: 3),
        ],
        .potomacAve: [
            .sunday: DateComponents(hour: 8, minute: 1),
            .weekday: DateComponents(hour: 5, minute: 1),
            .saturday: DateComponents(hour: 7, minute: 1),
        ],
        .stadium: [
            .sunday: DateComponents(hour: 7, minute: 59),
            .weekday: DateComponents(hour: 4, minute: 59),
            .saturday: DateComponents(hour: 6, minute: 59),
        ],
        .minnesotaAve: [
            .sunday: DateComponents(hour: 8, minute: 0),
            .weekday: DateComponents(hour: 5, minute: 0),
            .saturday: DateComponents(hour: 7, minute: 0),
        ],
        .deanwood: [
            .sunday: DateComponents(hour: 7, minute: 58),
            .weekday: DateComponents(hour: 4, minute: 58),
            .saturday: DateComponents(hour: 6, minute: 58),
        ],
        .cheverly: [
            .sunday: DateComponents(hour: 7, minute: 56),
            .weekday: DateComponents(hour: 4, minute: 56),
            .saturday: DateComponents(hour: 6, minute: 56),
        ],
        .landover: [
            .sunday: DateComponents(hour: 7, minute: 53),
            .weekday: DateComponents(hour: 4, minute: 53),
            .saturday: DateComponents(hour: 6, minute: 53),
        ],
        .newCarrollton: [
            .sunday: DateComponents(hour: 7, minute: 59),
            .weekday: DateComponents(hour: 4, minute: 59),
            .saturday: DateComponents(hour: 6, minute: 59),
        ],
        .mtVernonSq7thSt: [
            .sunday: DateComponents(hour: 8, minute: 14),
            .weekday: DateComponents(hour: 5, minute: 14),
            .saturday: DateComponents(hour: 7, minute: 14),
        ],
        .shaw: [
            .sunday: DateComponents(hour: 8, minute: 13),
            .weekday: DateComponents(hour: 5, minute: 13),
            .saturday: DateComponents(hour: 7, minute: 13),
        ],
        .uStreet: [
            .sunday: DateComponents(hour: 8, minute: 11),
            .weekday: DateComponents(hour: 5, minute: 11),
            .saturday: DateComponents(hour: 7, minute: 11),
        ],
        .columbiaHeights: [
            .sunday: DateComponents(hour: 8, minute: 9),
            .weekday: DateComponents(hour: 5, minute: 9),
            .saturday: DateComponents(hour: 7, minute: 9),
        ],
        .georgiaAve: [
            .sunday: DateComponents(hour: 8, minute: 6),
            .weekday: DateComponents(hour: 5, minute: 6),
            .saturday: DateComponents(hour: 7, minute: 6),
        ],
        .fortTottenLower: [
            .sunday: DateComponents(hour: 8, minute: 0),
            .weekday: DateComponents(hour: 5, minute: 0),
            .saturday: DateComponents(hour: 7, minute: 0),
        ],
        .westHyattsville: [
            .sunday: DateComponents(hour: 7, minute: 59),
            .weekday: DateComponents(hour: 4, minute: 59),
            .saturday: DateComponents(hour: 6, minute: 59),
        ],
        .princeGeorgesPlaza: [
            .sunday: DateComponents(hour: 7, minute: 56),
            .weekday: DateComponents(hour: 4, minute: 56),
            .saturday: DateComponents(hour: 6, minute: 56),
        ],
        .collegePark: [
            .sunday: DateComponents(hour: 7, minute: 53),
            .weekday: DateComponents(hour: 4, minute: 53),
            .saturday: DateComponents(hour: 6, minute: 53),
        ],
        .greenbelt: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50),
        ],
        .galleryPlaceLower: [
            .sunday: DateComponents(hour: 8, minute: 15),
            .weekday: DateComponents(hour: 5, minute: 15),
            .saturday: DateComponents(hour: 7, minute: 15),
        ],
        .archives: [
            .sunday: DateComponents(hour: 8, minute: 13),
            .weekday: DateComponents(hour: 5, minute: 13),
            .saturday: DateComponents(hour: 7, minute: 13),
        ],
        .lenfantPlazaUpper: [
            .sunday: DateComponents(hour: 8, minute: 9),
            .weekday: DateComponents(hour: 5, minute: 9),
            .saturday: DateComponents(hour: 7, minute: 9),
        ],
        .waterfront: [
            .sunday: DateComponents(hour: 8, minute: 9),
            .weekday: DateComponents(hour: 5, minute: 9),
            .saturday: DateComponents(hour: 7, minute: 9),
        ],
        .navyYard: [
            .sunday: DateComponents(hour: 8, minute: 7),
            .weekday: DateComponents(hour: 5, minute: 7),
            .saturday: DateComponents(hour: 7, minute: 7),
        ],
        .anacostia: [
            .sunday: DateComponents(hour: 8, minute: 4),
            .weekday: DateComponents(hour: 5, minute: 4),
            .saturday: DateComponents(hour: 7, minute: 4),
        ],
        .congressHeights: [
            .sunday: DateComponents(hour: 8, minute: 1),
            .weekday: DateComponents(hour: 5, minute: 1),
            .saturday: DateComponents(hour: 7, minute: 1),
        ],
        .southernAvenue: [
            .sunday: DateComponents(hour: 7, minute: 59),
            .weekday: DateComponents(hour: 4, minute: 59),
            .saturday: DateComponents(hour: 6, minute: 59),
        ],
        .naylorRoad: [
            .sunday: DateComponents(hour: 7, minute: 56),
            .weekday: DateComponents(hour: 4, minute: 56),
            .saturday: DateComponents(hour: 6, minute: 56),
        ],
        .suitland: [
            .sunday: DateComponents(hour: 7, minute: 53),
            .weekday: DateComponents(hour: 4, minute: 53),
            .saturday: DateComponents(hour: 6, minute: 53),
        ],
        .branchAve: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50),
        ],
        .benningRoad: [
            .sunday: DateComponents(hour: 7, minute: 55),
            .weekday: DateComponents(hour: 4, minute: 55),
            .saturday: DateComponents(hour: 6, minute: 55),
        ],
        .capitolHeights: [
            .sunday: DateComponents(hour: 7, minute: 52),
            .weekday: DateComponents(hour: 4, minute: 52),
            .saturday: DateComponents(hour: 6, minute: 52),
        ],
        .addisonRoad: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50),
        ],
        .morganBoulevard: [
            .sunday: DateComponents(hour: 7, minute: 47),
            .weekday: DateComponents(hour: 4, minute: 47),
            .saturday: DateComponents(hour: 6, minute: 47),
        ],
        .largoTownCenter: [
            .sunday: DateComponents(hour: 7, minute: 44),
            .weekday: DateComponents(hour: 4, minute: 44),
            .saturday: DateComponents(hour: 6, minute: 44),
        ],
        .vanDornStreet: [
            .sunday: DateComponents(hour: 7, minute: 56),
            .weekday: DateComponents(hour: 4, minute: 56),
            .saturday: DateComponents(hour: 6, minute: 56),
        ],
        .franconia: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50),
        ],
        .courtHouse: [
            .sunday: DateComponents(hour: 8, minute: 10),
            .weekday: DateComponents(hour: 5, minute: 10),
            .saturday: DateComponents(hour: 7, minute: 10),
        ],
        .clarendon: [
            .sunday: DateComponents(hour: 8, minute: 8),
            .weekday: DateComponents(hour: 5, minute: 8),
            .saturday: DateComponents(hour: 7, minute: 8),
        ],
        .virginiaSquare: [
            .sunday: DateComponents(hour: 8, minute: 7),
            .weekday: DateComponents(hour: 5, minute: 7),
            .saturday: DateComponents(hour: 7, minute: 7),
        ],
        .ballston: [
            .sunday: DateComponents(hour: 8, minute: 9),
            .weekday: DateComponents(hour: 5, minute: 9),
            .saturday: DateComponents(hour: 7, minute: 9),
        ],
        .eastFallsChurch: [
            .sunday: DateComponents(hour: 8, minute: 1),
            .weekday: DateComponents(hour: 5, minute: 1),
            .saturday: DateComponents(hour: 7, minute: 1),
        ],
        .westFallsChurch: [
            .sunday: DateComponents(hour: 7, minute: 58),
            .weekday: DateComponents(hour: 4, minute: 58),
            .saturday: DateComponents(hour: 6, minute: 58),
        ],
        .dunnLoring: [
            .sunday: DateComponents(hour: 7, minute: 54),
            .weekday: DateComponents(hour: 4, minute: 54),
            .saturday: DateComponents(hour: 6, minute: 54),
        ],
        .vienna: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50),
        ],
        .mcLean: [
            .sunday: DateComponents(hour: 8, minute: 3),
            .weekday: DateComponents(hour: 5, minute: 3),
            .saturday: DateComponents(hour: 7, minute: 3),
        ],
        .tysonsCorner: [
            .sunday: DateComponents(hour: 8, minute: 1),
            .weekday: DateComponents(hour: 5, minute: 1),
            .saturday: DateComponents(hour: 7, minute: 1),
        ],
        .greensboro: [
            .sunday: DateComponents(hour: 7, minute: 59),
            .weekday: DateComponents(hour: 4, minute: 59),
            .saturday: DateComponents(hour: 6, minute: 59),
        ],
        .springHill: [
            .sunday: DateComponents(hour: 7, minute: 57),
            .weekday: DateComponents(hour: 4, minute: 57),
            .saturday: DateComponents(hour: 6, minute: 57),
        ],
        .wiehle: [
            .sunday: DateComponents(hour: 7, minute: 50),
            .weekday: DateComponents(hour: 4, minute: 50),
            .saturday: DateComponents(hour: 6, minute: 50),
        ],
    ]
}
