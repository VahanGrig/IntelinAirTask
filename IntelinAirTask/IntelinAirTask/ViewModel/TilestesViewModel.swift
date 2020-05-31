//
//  TilestesViewModel.swift
//  IntelinViewModel
//
//  Created by Vahan Grigoryan on 5/29/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import Foundation
import IntelinAirTaskModel
import IntelinAirTaskBinding
import IntelinAirTaskExtensions
import IntelinAirTaskNetworking

final class TilestesViewModel {
    
    let flightInfo: Container<FlightInfo?> = Container(nil)
    var apiClient: FlightInfoNetworkProtocol?
    var tilesetViewModels: [TilesetViewModel]?
    var tilesets: [Tileset]?
    var urlString: String?
    
    init(with apiClient: FlightInfoNetworkProtocol = APIClient.shared, urlString: String?) {
        self.apiClient = apiClient
        self.urlString = urlString
    }
    
    func getFlightInfo() {
        guard let urlString = self.urlString else { return }
        apiClient?.fetchFlightInfo(from: urlString, completion: { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let flightInfo):
                self.updateTilesetViewModels(from: flightInfo)
                self.flightInfo.value = flightInfo
            }
        })
    }
    
    private func updateTilesetViewModels(from flightInfo: FlightInfo?) {
        guard let flightInfo = flightInfo, let tilesets = flightInfo.flights?.flatMap({$0.tilesets}) else { return }
        self.tilesets = tilesets
        for tileset in tilesets {
            let flightNumber = flightInfo.flights?.filter({$0.tilesets.contains { (tilesetSecond) -> Bool in
                return tilesetSecond.exportGeotiffThumbnail == tileset.exportGeotiffThumbnail
                }}).first?.flightNumber
            let flightDescription = "Flight Number \(flightNumber ?? -1)"
            let titlesetType = tileset.name
            let titlesetImageUrl = URL(string: tileset.exportGeotiffThumbnail ?? "")
            let tilesetViewModel = TilesetViewModel(tileSetImageUrl: titlesetImageUrl,
                                                    tileType: titlesetType,
                                                    tileDescription: flightDescription)
            if self.tilesetViewModels == nil {
                self.tilesetViewModels = [TilesetViewModel]()
            }
            self.tilesetViewModels?.append(tilesetViewModel)
        }
    }
    
}
