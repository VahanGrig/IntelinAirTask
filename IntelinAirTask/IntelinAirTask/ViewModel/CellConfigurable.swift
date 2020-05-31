//
//  CellConfigurable.swift
//  IntelinAirTask
//
//  Created by Vahan Grigoryan on 5/31/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import Foundation

protocol CellViewModel {}

protocol CellConfigurable {
    func setup(viewModel: CellViewModel?)
}
