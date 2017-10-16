//
//  ViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 11/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

	let locationManager = CLLocationManager()
	let defaultLocation = CLLocationCoordinate2DMake(CLLocationDegrees(50.847974), CLLocationDegrees(4.350370))
	let zoomDistance: CLLocationDistance = 700
	
	
	@IBOutlet weak var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		zoomToUserLocation()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .denied {
			let alert = UIAlertController(title: "Location permission not granted", message: "Please allow this app to get your location when in use for a better user experience under \nSettings > Privacy > Location Services", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		} else if status == .authorizedWhenInUse{
			zoomToUserLocation()
			mapView.showsUserLocation = true
		}
	}
	
	func zoomToUserLocation() {
		let viewRegion: MKCoordinateRegion
		if let userCurrentLoc = locationManager.location?.coordinate {
			viewRegion = MKCoordinateRegionMakeWithDistance(userCurrentLoc, zoomDistance, zoomDistance)
		} else {
			viewRegion = MKCoordinateRegionMakeWithDistance(defaultLocation, zoomDistance, zoomDistance)
		}
		mapView.setRegion(viewRegion, animated: true)
	}


}

