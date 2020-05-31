//
//  FlightInfo.swift
//  Models
//
//  Created by Vahan Grigoryan on 5/29/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import Foundation
 
public struct FlightInfo: Codable {
    public let flights: [Flight]?
    public let geometry: String?
}
