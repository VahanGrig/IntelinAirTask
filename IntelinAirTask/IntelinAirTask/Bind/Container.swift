//
//  Container.swift
//  IntelinAirTask
//
//  Created by Vahan Grigoryan on 5/31/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import Foundation

public class Container<T> {
    public typealias Listener = (T) -> Void
    var listener: Listener?
    
    public var value: T {
        didSet {
            listener?(value)
        }
    }
    
    public  init(_ value: T) {
        self.value = value
    }
    
    public func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
}
