//
//  Networking.swift
//  Networking
//
//  Created by Vahan Grigoryan on 5/29/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import Foundation
import IntelinAirTaskModel
import IntelinAirTaskExtensions

public class APIClient: FlightInfoNetworkProtocol {
 
   public static let shared = APIClient()
    
    public func fetchFlightInfo(from urlString: String, completion: @escaping (Result<FlightInfo, Error>) -> Void) {
       
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                completion(data.decode())
            }
        }.resume()
        
    }
    
}

public protocol FlightInfoNetworkProtocol {
    
    func fetchFlightInfo(from urlString: String, completion: @escaping (Result<FlightInfo, Error>) -> Void)
    
}
