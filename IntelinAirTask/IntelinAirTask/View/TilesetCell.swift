//
//  TilesetCell.swift
//  air
//
//  Created by Vahan Grigoryan on 5/28/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import UIKit
import IntelinAirTaskExtensions
import IntelinAirTaskViewModel

class TilesetCell: UITableViewCell, CellConfigurable  {

    @IBOutlet private weak var tileImageView: UIImageView!
    @IBOutlet private weak var tileTypeLabel: UILabel!
    @IBOutlet private weak var tileDescriptionLabel: UILabel!
    
    private var imageUrl: URL? {
            didSet {
                tileImageView?.download(from: imageUrl, contentMode: .scaleAspectFill, placeholder: UIImage(named: "map"))
            }
    }
    
    func setup(viewModel: CellViewModel?) {
        if let viewModel = viewModel as? TilesetViewModel {
            imageUrl = viewModel.tileSetImageUrl
            tileTypeLabel.text = viewModel.tileType
            tileDescriptionLabel.text = viewModel.tileDescription
            
        }
    }

}
