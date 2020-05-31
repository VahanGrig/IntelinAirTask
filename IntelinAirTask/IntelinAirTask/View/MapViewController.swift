//
//  MapViewController.swift
//  air
//
//  Created by Vahan Grigoryan on 5/28/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import UIKit
import Mapbox
import IntelinAirTaskViewModel

class MapViewController: UIViewController  {
    
    @IBOutlet private weak var mapView: MGLMapView!
    
    private var rasterLayer: MGLRasterStyleLayer?
    private var polylineSource: MGLShapeSource?
    private var allCoordinates: [CLLocationCoordinate2D]! {
        return viewModel?.coordinates() ?? []
    }
    
    var viewModel: MapViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurationInitialView()
    }
    
    private func configurationInitialView() {
        if let centerCoordinate = viewModel?.coordinates()?.last {
            mapView.setCenter(centerCoordinate, zoomLevel: 13, animated: false)
        }
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.styleURL = MGLStyle.satelliteStyleURL
        
    }
    
    private func binding() {
        viewModel?.tileset.bind(listener: { (tilset) in
            self.mapView.reloadInputViews()
        })
    }
    
}

extension MapViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        if let pathString = viewModel?.tileset.value?.path {
            let source = MGLRasterTileSource(identifier: pathString,
                                             tileURLTemplates: [pathString],
                                             options: [ .tileSize: 256])
            let rasterLayer = MGLRasterStyleLayer(identifier: "stamen-watercolor",
                                                  source: source)
            
            style.addSource(source)
            style.addLayer(rasterLayer)
            self.rasterLayer = rasterLayer
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        addPolyline(to: mapView.style)
    }
    
    private func addPolyline(to style: MGLStyle?) {
        let source = MGLShapeSource(identifier: IntelinAirTaskStrings.sourceIdentifier.rawValue, shape: nil, options: nil)
        style?.addSource(source)
        polylineSource = source
        
        polylineSource?.shape = MGLPolylineFeature(coordinates: allCoordinates, count: UInt(allCoordinates.count))
        
        let layer = MGLLineStyleLayer(identifier: IntelinAirTaskStrings.sourceIdentifier.rawValue,
                                      source: source)
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        layer.lineColor = NSExpression(forConstantValue: UIColor.orange)
        
        // The line width should gradually increase based on the zoom level.
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 5, 18: 20])
        style?.addLayer(layer)
    }
    
}
