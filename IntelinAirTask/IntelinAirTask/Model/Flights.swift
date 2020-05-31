//
//  Flights.swift
//  Models
//
//  Created by Vahan Grigoryan on 5/29/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import Foundation

public struct Flight: Codable {
    public let tilesets: [Tileset]
    public let flightNumber: Int?
}
