//
//  Geometry.swift
//  Models
//
//  Created by Vahan Grigoryan on 5/29/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import Foundation

public struct Geometry: Codable {
    public let coordinates: [[[[Double]]]]?
    public let type: String?
}

public struct Features: Codable {
   public let features: [Fiture]
}

public struct Fiture: Codable {
   public let geometry: Geometry?
}

