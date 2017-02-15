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
   var pins:[MKPointAnnotation]=[]
   var pinCount:Int = 0
   var locStatus: Bool = false
   var currentLoc: CLLocationCoordinate2D!
   var currentSpan: MKCoordinateSpan!
   
   override func loadView() {
      // Create a map view 
      mapView = MKMapView()
      mapView.delegate = self
      
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
      //Constraints
      let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
      let margins = view.layoutMarginsGuide
      let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
      let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
   
      
      topConstraint.isActive = true
      leadingConstraint.isActive = true
      trailingConstraint.isActive = true
      
      initLocationButton(segmentedControl)
      initPinButton(segmentedControl)
      
   }
      
   func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
      //This is a method from MKMapViewDelegate, runs when the user`s location changes
      let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
      mapView.setRegion(zoomedInCurrentLocation, animated: true)
   }
   
   //Initializes Location Button
   func initLocationButton(_ anyView: UIView!){
      let locationButton = UIButton.init(type: .system)
      locationButton.setTitle("Location", for: .normal)
      locationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
      locationButton.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(locationButton)
      
      //Constraints
      let topConstraint = locationButton.topAnchor.constraint(equalTo:anyView
         .topAnchor, constant: 32 )
      let trailingConstraint = locationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
      topConstraint.isActive = true
      trailingConstraint.isActive = true
      
      locationButton.addTarget(self, action: #selector(MapViewController.showLocation(sender:)), for: .touchDown)
   }
   
   func showLocation(sender: UIButton!){
      if(mapView.showsUserLocation == false){
         currentLoc = self.mapView.centerCoordinate
         currentSpan = self.mapView.region.span
         mapView.showsUserLocation = true
      }
      if(locStatus == true){
         let span:MKCoordinateSpan = MKCoordinateSpanMake(currentSpan.latitudeDelta,currentSpan.longitudeDelta)
         let region: MKCoordinateRegion = MKCoordinateRegionMake(currentLoc, span)
         mapView.setRegion(region, animated: true)
         mapView.showsUserLocation = false
         locStatus = false
      }else{
         locationManager.requestWhenInUseAuthorization()
         mapView.showsUserLocation = true
         locStatus = true
      }
      
   }
   //Initializes Pins Button
   func initPinButton(_ anyView: UIView!){
      let pinButton = UIButton.init(type: .system)
      pinButton.setTitle("Pins", for: .normal)
      pinButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
      pinButton.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(pinButton)
      
      //Constraints
      let topConstraint = pinButton.topAnchor.constraint(equalTo:anyView
         .topAnchor, constant: 32 )
      let leadingConstraint = pinButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
      topConstraint.isActive = true
      leadingConstraint.isActive = true
      
      currentLoc = self.mapView.centerCoordinate
      currentSpan = self.mapView.region.span
      pinButton.addTarget(self, action: #selector(MapViewController.showPins(sender:)), for: .touchDown)
      
   }
   
   func showPins(sender: UIButton!){
      //set current location when not in pin cycle
      if(pinCount==0){
         currentLoc = self.mapView.centerCoordinate
         currentSpan = self.mapView.region.span
      }
      //1st Pin - Home, Waxhaw, NC
      let homePin = MKPointAnnotation()
      let homeCoord = CLLocationCoordinate2D(latitude: 34.9246 , longitude: -80.7434)
      homePin.coordinate = homeCoord
      mapView.addAnnotation(homePin)
      pins.append(homePin)
      
      //2nd Pin - Nashville, TN
      let nashvillePin = MKPointAnnotation()
      let nashvilleCoord = CLLocationCoordinate2D(latitude: 36.1627, longitude: -86.7816)
      nashvillePin.coordinate = nashvilleCoord
      mapView.addAnnotation(nashvillePin)
      pins.append(nashvillePin)
      
      //3rd Pin - Charleston, SC
      let vacationPin = MKPointAnnotation()
      let vacationCoord = CLLocationCoordinate2D(latitude: 32.7765, longitude: -79.9311)
      vacationPin.coordinate = vacationCoord
      mapView.addAnnotation(vacationPin)
      pins.append(vacationPin)
      
      //Cycles through 3 pins
      print("Button tapped. pinCount=",pinCount)
      mapView.showAnnotations([pins[pinCount]], animated: true)
      pinCount=(pinCount+1)
      if(pinCount==4){
         let span:MKCoordinateSpan = MKCoordinateSpanMake(currentSpan.latitudeDelta,currentSpan.longitudeDelta)
         let region: MKCoordinateRegion = MKCoordinateRegionMake(currentLoc, span)
         mapView.setRegion(region, animated: true)
         mapView.showsUserLocation = false
         pinCount = 0
      }
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
