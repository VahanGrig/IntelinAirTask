//
//  TilesetsViewController.swift
//  air
//
//  Created by Vahan Grigoryan on 5/28/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import UIKit
import IntelinAirTaskModel
import IntelinAirTaskViewModel

final class TilesetsViewController: UITableViewController {
    
    let viewModel = TilestesViewModel(urlString: IntelinAirTaskStrings.baseUrlString.rawValue)
    private lazy var activityIndicator: UIActivityIndicatorView = {
        UIActivityIndicatorView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurationInitialView()
    }
    
    private func configurationInitialView() {
        tableView.tableFooterView = UIView()
        addActivityIndicator()
        activityIndicator.startAnimating()
        viewModel.getFlightInfo()
        binding()
    }
    
    private func binding() {
        viewModel.flightInfo.bind { [weak self] (fli) in
            
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func addActivityIndicator() {
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.style = .medium
        activityIndicator.color = .green
        view.addSubview(activityIndicator);
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mapVC = segue.destination as? MapViewController {
            let tileset = sender as? Tileset
            mapVC.viewModel = MapViewModel(with: tileset, geomertyString: viewModel.flightInfo.value?.geometry)
        }
    }
}

// MARK: - Table view data source
extension TilesetsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.tilesetViewModels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IntelinAirTaskStrings.tilesetCellId.rawValue) as! TilesetCell
        let tilesetViewModel = viewModel.tilesetViewModels?[indexPath.row]
        cell.setup(viewModel: tilesetViewModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "map", sender: viewModel.tilesets?[indexPath.row])
    }
    
}
