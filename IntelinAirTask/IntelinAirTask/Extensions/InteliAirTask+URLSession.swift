//
//  InteliAirTask+URLSession.swift
//  IntelinAirTask
//
//  Created by Vahan Grigoryan on 5/31/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import Foundation

extension URLSession {
    
    public func dataTask(with url: URL, completionHandler: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url, completionHandler: { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.failure(error))
                } else if let data = data {
                    completionHandler(.success(data))
                }
            }
        })
    }
    
}

protocol ErrorProtocol: LocalizedError {
    var code: Int { get set }
    var message: String {get set}
    var error: String? { get set}
    var errorDescription: String? { get }
    var localizedDescription: String { get }
}

public struct IntelinAirTaskError: ErrorProtocol {
       var code: Int
       var message: String
       var error: String?
       
    public var errorDescription: String? { return message }
       var localizedDescription: String { return message }
    
   public init(message: String?, error: String?, code: Int) {
        self.message = message ?? "Error"
        self.error = error
        self.code = code
    }
}

