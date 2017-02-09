//
//  MapViewController.swift
//  WorldTrotter-V2
//
//  Created by Alexis Kirkman on 2/6/17.
//  Copyright © 2017 Alexis Kirkman. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
   var mapView: MKMapView!
   let locationManager = CLLocationManager()
   //Silver Challenge
   
   
   
   
   //End of Class Code
   
   override func loadView() {
      // Create a map view 
      mapView = MKMapView()
      mapView.delegate = self
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestAlwaysAuthorization()
      locationManager.startUpdatingLocation()
      
      // Set it as *the* view of this view controller
      view = mapView
      let standardString = NSLocalizedString("Standard", comment: "Standard map view")
      let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
      let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
      let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
      
      segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
      segmentedControl.selectedSegmentIndex = 0
      
      segmentedControl.addTarget(self,
                                 action: #selector(MapViewController.mapTypeChanged(_:))
                                 ,for: .valueChanged)
      
      segmentedControl.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(segmentedControl)
      
      let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
      let margins = view.layoutMarginsGuide
      let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
      let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
   
      
      topConstraint.isActive = true
      leadingConstraint.isActive = true
      trailingConstraint.isActive = true
      
      initLocalizationButton(segmentedControl)
      
      
   }
   
   func showLocalization(sender: UIButton!){
      locationManager.requestWhenInUseAuthorization()//se agrega permiso en info.plist
      mapView.showsUserLocation = true //fire up the method mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
   }
   
   func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
      //This is a method from MKMapViewDelegate, fires up when the user`s location changes
      let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
      mapView.setRegion(zoomedInCurrentLocation, animated: true)
   }
   
   func initLocalizationButton(_ anyView: UIView!){
      let localizationButton = UIButton.init(type: .system)
      localizationButton.setTitle("Localization", for: .normal)
      localizationButton.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(localizationButton)
      
      //Constraints
      
      let topConstraint = localizationButton.topAnchor.constraint(equalTo:anyView
         .topAnchor, constant: 32 )
      let leadingConstraint = localizationButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
      let trailingConstraint = localizationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
      
      topConstraint.isActive = true
      leadingConstraint.isActive = true
      trailingConstraint.isActive = true
      
      localizationButton.addTarget(self, action: #selector(MapViewController.showLocalization(sender:)), for: .touchUpInside)
      
      
   }
   
     func mapTypeChanged(_ segControl: UISegmentedControl) {
      switch segControl.selectedSegmentIndex {
      case 0:
         mapView.mapType = .standard
      case 1:
         mapView.mapType = .hybrid
      case 2:
         mapView.mapType = .satellite
      default:
         break
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      print("MapViewController loaded its view.")
   }
   
}
