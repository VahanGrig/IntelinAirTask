//
//  MapViewModel.swift
//  IntelinViewModel
//
//  Created by Vahan Grigoryan on 5/29/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import Foundation
import MapKit
import IntelinAirTaskModel
import IntelinAirTaskBinding

final class MapViewModel {
    
    let tileset: Container<Tileset?> = Container(nil)
    private var geometryString: String?
    private var geometry: Geometry?
    
    init(with tileset: Tileset?, geomertyString: String?) {
        self.tileset.value = tileset
        self.geometryString = geomertyString
    }
    
    func coordinates() -> [CLLocationCoordinate2D]? {
        do {
            guard let geoString = geometryString else { return nil }
            let data = Data(geoString.utf8)
            let features = try JSONDecoder().decode(Features.self, from: data)
            return getCoordinates(from: features)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func getCoordinates(from features: Features) -> [CLLocationCoordinate2D] {
        var locations = [CLLocationCoordinate2D]()
        if let firstCollection = features.features.first?.geometry?.coordinates?.first?.first,
            let secondCollection = features.features.first?.geometry?.coordinates?.first?.last {
            for cord in (firstCollection + secondCollection) {
                if let latitude = cord.last, let longitude =  cord.first {
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    locations.append(location)
                }
            }
        }
        return locations
    }
    
}
