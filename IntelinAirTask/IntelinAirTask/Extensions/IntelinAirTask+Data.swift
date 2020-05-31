//
//  IntelinAirTask+Data.swift
//  IntelinAirTask
//
//  Created by Vahan Grigoryan on 5/31/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import Foundation

extension Data {
    
    public func decode<T: Decodable>(with decoder: JSONDecoder = .init()) -> Result<T, Error> {
        do {
            let decoded = try decoder.decode(T.self, from: self)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
    
}
