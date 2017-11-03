//
//  StoreDetailsViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 22/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase

class StoreDetailsViewController: UIViewController {
	var isAuthenticated = (Auth.auth().currentUser == nil) ? false : true
	lazy var currentUserFavDBRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("favorites")
	var favorites : DataSnapshot!
	var storeInFavorites: Bool! {
		didSet {
			manageFavoriteButton()
		}
	}
	var store: Store! = nil

	
	@IBOutlet weak var storeNameLabel: UILabel!
	@IBOutlet weak var storeTimeTableLabel: UILabel!
	@IBOutlet weak var storeTelephoneLabel: UILabel!
	@IBOutlet weak var storeWebsiteLabel: UILabel!
	@IBOutlet weak var storeAddressLabel: UILabel!
	@IBOutlet weak var favoriteButton: UIButton!
	
	@IBAction func navigateButtonTapped() {
		 self.mapItem().openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
	}
	
	@IBAction func favoriteButtonTapped() {
		currentUserFavDBRef.child(store.dbId).setValue("", withCompletionBlock: { (err, dbRef) in
			if let err = err {
				print(err.localizedDescription)
			} else {
				self.favoriteButton.isEnabled = false
				self.favoriteButton.setTitle("Added to favorites", for: .disabled)
			}
		})
	}
	
	func mapItem() -> MKMapItem {
		
		let placemark = MKPlacemark(coordinate: store.coordinate)
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = store.title
		
		return mapItem
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		if(isAuthenticated) {
			isStoreInFavorite()
		} else {
			favoriteButton.isEnabled = false
			favoriteButton.setTitle("For registered users only", for: .disabled)
		}
		populateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func populateLabels() {
		storeNameLabel.text = store.name
		storeTimeTableLabel.text = "Timetable : \(store.openingTime)-\(store.closingTime)"
		if store.telephone != "" {
			storeTelephoneLabel.text = store.telephone
		}
		if store.website?.absoluteString != "" {
			storeWebsiteLabel.text = store.website?.absoluteString
		}
		storeAddressLabel.text = store.fullAddress()
	}

//	func isUserLoggedIn() -> Bool {
//		return (Auth.auth().currentUser == nil) ? false : true
//	}
	
	func manageFavoriteButton() {
		if (storeInFavorites) {
			favoriteButton.setTitle("Added to favorites", for: .disabled)
			favoriteButton.isEnabled = false
		} else {
			favoriteButton.setTitle("Add to favorites", for: .normal)
			favoriteButton.isEnabled = true
		}
	}
	
	func isStoreInFavorite() {
		currentUserFavDBRef.observeSingleEvent(of: .value, with: { (dataSnapshot) in
			self.storeInFavorites = dataSnapshot.hasChild(self.store.dbId)
		})
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
