//
//  MapViewController.swift
//  WorldTrotter-V2
//
//  Created by Alexis Kirkman on 2/6/17.
//  Copyright © 2017 Alexis Kirkman. All rights reserved.
//  MapViewController sets up layout of MapView tab in app, creates
//  buttons and sets up actions to be executed when buttons are pressed.

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
   var mapView: MKMapView!
   let locationManager = CLLocationManager()
   var pins:[MKPointAnnotation]=[] //pins array
   var pinCount:Int = 0 // keeps track of which pin is currently displayed
   var locStatus: Bool = false // location button pressed or unpressed
   var currentLoc: CLLocationCoordinate2D! // keeps track of current location
   var currentSpan: MKCoordinateSpan! // holds span/zoom info for a location
   
   /* Function: loadView() is overridden to create a view controller's
                view programmatically. Initiates MapView buttons, that 
                switch from standard, satellite, and hybrid view and 
                establishes constraints for thesee objects. Also calls 
                2 other init functions which will initialize the location
                and pins buttons as well.
    */
   override func loadView() {
      // Create a map view 
      mapView = MKMapView()
      mapView.delegate = self
      
      // Set it as the view of this view controller
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
      
      //Initialize location and pin buttons
      initLocationButton(segmentedControl)
      initPinButton(segmentedControl)
      
   }
   
/* Function: mapView is a method from MKMapViewDelegate,
             that runs when the user`s location changes.
*/
   func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
      let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
      mapView.setRegion(zoomedInCurrentLocation, animated: true)
   }
   
/* Function: initLocationButton initializes the Location Button
             applies constrains on the object and implements .addTarget
             so that showLocation is called when the button is pressed
*/
   func initLocationButton(_ anyView: UIView!){
      let locationButton = UIButton.init(type: .system)
      locationButton.setTitle("Location", for: .normal)
      locationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
      locationButton.translatesAutoresizingMaskIntoConstraints = false
      locationButton.showsTouchWhenHighlighted = true
      view.addSubview(locationButton)
      
      //Constraints
      let topConstraint = locationButton.topAnchor.constraint(equalTo:anyView
         .topAnchor, constant: 32 )
      let trailingConstraint = locationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
      topConstraint.isActive = true
      trailingConstraint.isActive = true
      
      //showLocation is called when button is pressed
      locationButton.addTarget(self, action: #selector(MapViewController.showLocation(sender:)), for: .touchDown)
   }
   
/* Function: showLocation is called when location button is pressed
             if mapView.showsUserLocation is false, it takes in the 
             current location and span that the user is at on the map
             then goes to there set user location. If pressed again,
             it toggles between the showing the user location and 
             returning to the map location that the map was at previously.
             locStatus keeps track of which status the button is currently at.
*/
   func showLocation(sender: UIButton!){
      if(mapView.showsUserLocation == false){
         currentLoc = mapView.centerCoordinate
         currentSpan = mapView.region.span
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
   
/* Function: initPinButton initializes the pins button, applies
             constaints on the object and calls and addTarget for
             when the button is pressed. showPins is called when pin
             button is pressed
*/
   func initPinButton(_ anyView: UIView!){
      let pinButton = UIButton.init(type: .system)
      pinButton.setTitle("Pins", for: .normal)
      pinButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
      pinButton.translatesAutoresizingMaskIntoConstraints = false
      pinButton.showsTouchWhenHighlighted = true
      view.addSubview(pinButton)
      
      //Constraints
      let topConstraint = pinButton.topAnchor.constraint(equalTo:anyView
         .topAnchor, constant: 32 )
      let leadingConstraint = pinButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
      topConstraint.isActive = true
      leadingConstraint.isActive = true
      
      // When button is pressed calls showPins function
      pinButton.addTarget(self, action: #selector(MapViewController.showPins(sender:)), for: .touchDown)
      
   }
   
/* Function: showPins is called when the pins button is pressed. When pressed
             the map will cycle through displaying the 3 pins then will return
             to the default position on the 4th press.
*/
   func showPins(sender: UIButton!){
      //1st Pin - Home, Waxhaw, NC
      let homePin = MKPointAnnotation()
      let homeCoord = CLLocationCoordinate2D(latitude: 34.9246 , longitude: -80.7434)
      homePin.coordinate = homeCoord
      homePin.title = "Home"
      pins.append(homePin)
      
      //2nd Pin - Nashville, TN
      let nashvillePin = MKPointAnnotation()
      let nashvilleCoord = CLLocationCoordinate2D(latitude: 36.1627, longitude: -86.7816)
      nashvillePin.coordinate = nashvilleCoord
      nashvillePin.title = "Nashville,TN"
      pins.append(nashvillePin)
      
      //3rd Pin - Charleston, SC
      let vacationPin = MKPointAnnotation()
      let vacationCoord = CLLocationCoordinate2D(latitude: 32.7765, longitude: -79.9311)
      vacationPin.coordinate = vacationCoord
      vacationPin.title = "Charleston,SC"
      pins.append(vacationPin)
      
      //Adds & removes displayed pins based on pinCount
      if(pinCount==0){
         mapView.addAnnotation(homePin)
      }else if(pinCount==1){
         mapView.removeAnnotations(pins)
         mapView.addAnnotation(nashvillePin)
      }else if(pinCount==2){
         mapView.removeAnnotations(pins)
         mapView.addAnnotation(vacationPin)
      }else if(pinCount==3){
         let regionDistance:CLLocationDistance = 5000000
         let coordinates = CLLocationCoordinate2DMake(39.8282, -98.5795)
         let region = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
         mapView.setRegion(region, animated: true)
         mapView.showsUserLocation = false
         mapView.removeAnnotations(pins)
      }
      //Cycles through 3 pins
      print("Button tapped. pinCount=",pinCount)
      if(pinCount<3){
         mapView.showAnnotations([pins[pinCount]], animated: true)
      }
      pinCount=(pinCount+1)%4
   }
   
/* Function: mapTypeChanged will check which segment was selected
             and update the map accordingly.
*/
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
   
/* Function: viewDidLoad() is called after the view controller's
             interface file is loaded, at which point all of the view controller's
             outlets will reference the appropriate objects.
*/
   override func viewDidLoad() {
      super.viewDidLoad()
      print("MapViewController loaded its view.")
   }
   
}
