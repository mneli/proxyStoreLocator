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
import FirebaseDatabase
import SafariServices

class MapViewController: UIViewController{
	
	var dbRef: DatabaseReference!
	var dbRefHandle: DatabaseHandle!
	
	let locationManager = CLLocationManager()
	let defaultLocation = CLLocationCoordinate2DMake(CLLocationDegrees(50.847974), CLLocationDegrees(4.350370))
	let zoomDistance: CLLocationDistance = 700
	
	@IBOutlet weak var centerMapButton: UIButton!
	@IBOutlet weak var mapView: MKMapView!
	
	@IBAction func centerMapButtonTapped() {
		zoomToUserLocation()
	}
	
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
		mapView.delegate = self
		setupFirebaseDatabaseListener()
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		zoomToUserLocation()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is StoreDetailsViewController {
			if let destinationVC = segue.destination as? StoreDetailsViewController, let store = sender as? Store {
				destinationVC.store = store
			}
		}
	}
	
	deinit {
		dbRef.child(Constants.FirebaseKey.Stores).removeObserver(withHandle: dbRefHandle)
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
				performSegue(withIdentifier: "FavoritesListSegue", sender: nil)
			} else {
				askUserToLogIn()
			}
		case Constants.MenuItems.addStore:
			if isUserLoggedIn() {
				performSegue(withIdentifier: "AddStoreSegue", sender: nil)
			} else {
				askUserToLogIn()
			}
		case Constants.MenuItems.about:
			if let url = URL(string: "https://github.com/mneli/proxyStoreLocator/projects/1") {
				UIApplication.shared.open(url, options: [:])
			}
		default:
			return
		}
	}
	
	func loadInitialData() {
		dbRef = Database.database().reference()
		
	}
	
	func setupFirebaseDatabaseListener() {
		dbRef = Database.database().reference()
		dbRefHandle = dbRef.child(Constants.FirebaseKey.Stores).observe(DataEventType.childAdded, with: { (dataSnapshot) in
			if let storeData = dataSnapshot.value as? Dictionary<String, String> {
				let store = Store(dataSnapshot.key, storeData)
				self.mapView.addAnnotation(store)
			}
		})
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
	
	// TODO : move to authhelper
	func isUserLoggedIn() -> Bool {
		return (Auth.auth().currentUser == nil) ? false : true
	}
	
	func askUserToLogIn() {
		let alert = UIAlertController(title: "Not Available", message: "Please log in to use this feature", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action) in
			self.performSegue(withIdentifier: "LoginSegue", sender: nil)
		}))
		
		self.present(alert, animated: true, completion: nil)
	}
}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .denied {
			let alert = UIAlertController(title: "Location permission not granted",
			                              message: "Please allow this app to get your location when in use for a better user experience under \nSettings > Privacy > Location Services", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			centerMapButton.isHidden = true
		} else if status == .authorizedWhenInUse{
			zoomToUserLocation()
			mapView.showsUserLocation = true
			centerMapButton.isHidden = false
		}
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let annotation = annotation as? Store else { return nil }
		
		let identifier = "store"
//		var view: MKMarkerAnnotationView
		var view: MKAnnotationView
		
		if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
	 	{
			dequeuedView.annotation = annotation
			view = dequeuedView
		} else {
//			view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//			view.glyphImage = UIImage(named: "pin-icon")
			view.image = UIImage(named: "pin-icon")
			view.canShowCallout = true
			view.calloutOffset = CGPoint(x: -5, y: 5)
			view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
		}
		return view
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
	             calloutAccessoryControlTapped control: UIControl) {
		let store = view.annotation as! Store
		self.performSegue(withIdentifier: "StoreDetailsSegue", sender: store)
		
	}
	
}
