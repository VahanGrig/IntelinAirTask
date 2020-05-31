//
//  IntelinAirTaskTests.swift
//  IntelinAirTaskTests
//
//  Created by Vahan Grigoryan on 5/31/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import XCTest
import MapKit
@testable import IntelinAirTask
@testable import IntelinAirTaskModel
@testable import IntelinAirTaskViewModel
@testable import IntelinAirTaskExtensions
@testable import IntelinAirTaskNetworking


class IntelinAirTaskTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGoemetryParsing() throws {
        let geometryString = "{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"type\":\"MultiPolygon\",\"coordinates\":[[[[-87.7021646,40.331273],[-87.7032941,40.3312977],[-87.703237,40.330155],[-87.7021398,40.330138],[-87.7021411,40.3288222],[-87.7023199,40.3287639],[-87.7114955,40.3287846],[-87.711498,40.3290286],[-87.7116736,40.3290458],[-87.7144961,40.3290894],[-87.71737,40.329096],[-87.7208581,40.3291293],[-87.7209509,40.3288602],[-87.7209948,40.3289331],[-87.7210106,40.3292697],[-87.7212287,40.3358646],[-87.7214669,40.343129],[-87.7173037,40.3430944],[-87.7129523,40.343087],[-87.7122189,40.3430229],[-87.7026876,40.3430464],[-87.7026179,40.3429544],[-87.7021646,40.331273]],[[-87.7119603,40.3359035],[-87.7120125,40.3358425],[-87.7119945,40.3358021],[-87.7119236,40.3357688],[-87.7118351,40.3357356],[-87.7117384,40.3357632],[-87.7116067,40.335818],[-87.7116071,40.3358585],[-87.7116165,40.3359124],[-87.7116789,40.3359727],[-87.7117759,40.3359789],[-87.7118902,40.3359445],[-87.7119603,40.3359035]]]]},\"properties\":{\"fieldId\":114090,\"fieldName\":\"230\\/231 Clark 640\",\"token\":\"2d8bc780-31e8-497b-892b-74bedd77f3e3\"},\"id\":\"feature-0\"}]}"
        let mapViewModel = MapViewModel(with: nil, geomertyString: geometryString)
        let lastCoordinate = CLLocationCoordinate2D(latitude: 40.3359035, longitude: -87.7119603)
        XCTAssertNotNil(mapViewModel.coordinates(), "coordinaates not Parsed")
        XCTAssert(mapViewModel.coordinates()?.count == 36, "Parsing logic Error")
        XCTAssert(mapViewModel.coordinates()?.last == lastCoordinate, "Parsing logic Error")
    }
    
    func testTilesetModel() throws {
        let apiClient = MockFlightInfoNetworking()
        let promise = expectation(description: "Completion handler invoked")
        let currentBundle = Bundle(for: type(of: self))
        if let path = currentBundle.path(forResource: "FlightInfo", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decoder = JSONDecoder()
                apiClient.flightInfo = try? decoder.decode(FlightInfo.self, from: data)
            } catch let error {
                XCTAssertNil(error, "Parsing Error")
            }
        }
        
        
        let tilesetsViewMoodel = TilestesViewModel(with: apiClient, urlString: IntelinAirTaskStrings.baseUrlString)
        tilesetsViewMoodel.getFlightInfo()
        tilesetsViewMoodel.flightInfo.bind { (_) in
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        let tilesetViewModel = tilesetsViewMoodel.tilesetViewModels?.first
        XCTAssertNotNil(tilesetViewModel)
        XCTAssertEqual(tilesetViewModel?.tileSetImageUrl?.absoluteString, "https://s3.amazonaws.com/intelinair-prod-public/prod/flights/JRXVRDRR7/thumbnails/thermal.png")
        XCTAssertEqual(tilesetViewModel?.tileType, "thermal")
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

fileprivate class MockFlightInfoNetworking: FlightInfoNetworkProtocol {
    
    var flightInfo: FlightInfo?
    
    func fetchFlightInfo(from urlString: String, completion: @escaping (Result<FlightInfo, Error>) -> Void) {
        
        if let flightInnfo = flightInfo {
            completion(Result.success(flightInnfo))
        } else {
            let error = IntelinAirTaskError(message: "Parsing error", error: nil, code: -1)
            completion(Result.failure(error))
        }
        
    }
    
}

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lxp: CLLocationCoordinate2D, rxp: CLLocationCoordinate2D) -> Bool {
        guard lxp.longitude == rxp.longitude,
            lxp.latitude == rxp.latitude
        else {
            return false
        }
        return true
    }
}

