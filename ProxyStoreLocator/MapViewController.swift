//
//  ViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 11/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import SafariServices

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

	let locationManager = CLLocationManager()
	let defaultLocation = CLLocationCoordinate2DMake(CLLocationDegrees(50.847974), CLLocationDegrees(4.350370))
	let zoomDistance: CLLocationDistance = 700
	
	
	@IBOutlet weak var mapView: MKMapView!
	
	@IBAction func unWindToMap(unWindSegue: UIStoryboardSegue) {
		if unWindSegue.source is MenuViewController {
			if let segue = unWindSegue as? UIStoryboardSegueWithCompletion, let senderVC = unWindSegue.source as? MenuViewController {
				segue.completion = {
					self.performSegueWithMenuChoice(senderVC.choosenOption)
				}
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		zoomToUserLocation()
		mapView.delegate = self
		let store = createSingleStoreForTest()
		mapView.addAnnotation(store)
		
	}
	
	func createSingleStoreForTest() -> Store {
		return Store(name: "Some store", street: "Rue du midi 30", city: "1000 Brussels", openingTime: "18:00", closingTime: "02:00", telephone: "", website: "", coordinatesLat: "50.8469193", coordinatesLong: "4.3506287")
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		guard let annotation = annotation as? Store else { return nil }

		let identifier = "store"
		var view: MKMarkerAnnotationView
		
		if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
			as? MKMarkerAnnotationView {
			dequeuedView.annotation = annotation
			view = dequeuedView
		} else {
			
			view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			view.canShowCallout = true
			view.calloutOffset = CGPoint(x: -5, y: 5)
			view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
		}
		return view
	}
	
	
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
	             calloutAccessoryControlTapped control: UIControl) {
		let store = view.annotation as! Store
//		let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//		location.mapItem().openInMaps(launchOptions: launchOptions)
		self.performSegue(withIdentifier: "StoreDetailsSegue", sender: store)
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is StoreDetailsViewController {
			if let destinationVC = segue.destination as? StoreDetailsViewController, let store = sender as? Store {
				destinationVC.store = store
			}
		}
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
	
	
	func performSegueWithMenuChoice( _ choice : String ) {
		//TODO : refactor checklogin cases
		switch choice {
		case Constants.MenuItems.profile:
			if isUserLoggedIn() {
				performSegue(withIdentifier: "ProfileSegue", sender: nil)
			} else {
				performSegue(withIdentifier: "LoginSegue", sender: nil)
			}
		case Constants.MenuItems.favorites:
			if isUserLoggedIn() {
				performSegue(withIdentifier: "FavoritesSegue", sender: nil)
			} else {
				performSegue(withIdentifier: "LoginSegue", sender: nil)
			}
		case Constants.MenuItems.addStore:
			if isUserLoggedIn() {
				performSegue(withIdentifier: "AddStoreSegue", sender: nil)
			} else {
				performSegue(withIdentifier: "LoginSegue", sender: nil)
			}
		case Constants.MenuItems.about:
			if let url = URL(string: "https://www.apple.com") {
				// open browser option
				// UIApplication.shared.open(url, options: [:])
				// open page inside app option
				let safariViewController = SFSafariViewController(url: url)
				present(safariViewController, animated: true, completion: nil)
				
			}
		default:
			return
		}
		
	}
	
	// TODO : move to authhelper
	func isUserLoggedIn() -> Bool {
		return (Auth.auth().currentUser == nil) ? false : true
	}


}

