//
//  AddStoreViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 18/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Eureka
import CoreLocation

class AddStoreViewController: FormViewController {

	var dbRef: DatabaseReference!
	lazy var geocoder = CLGeocoder()
	
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		
		if (form.validate().isEmpty) {
			var storeDataDictionary = formatFormDataToDictionary()
			
			let fullAddressForGeocoder = "\(storeDataDictionary[Constants.StoreKey.street]!), \(storeDataDictionary[Constants.StoreKey.city]!)"
			
			geocoder.geocodeAddressString(fullAddressForGeocoder) { (placemarks, error) in
				let coordinates = self.processGeocoderResponse(withPlacemarks: placemarks, error: error)
				if (coordinates != nil){
					storeDataDictionary[Constants.StoreKey.cLatitude] = String(describing: coordinates!.latitude)
					storeDataDictionary[Constants.StoreKey.cLongitude] = String(describing: coordinates!.longitude)
					self.addStoreToFirebaseDatabase(storeDataDictionary)
				} else {
					Utilities().showAlert(title: "Invalid address", message: "Please enter a valid address to add", viewController: self, actionTitle: "Dismiss", actionStyle: .cancel)
				}
				
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		createForm()
		dbRef = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func formatFormDataToDictionary() -> [String : String] {
		//TODO : reformat data treatment using Store class
		let formValues = form.values()
		var store = [String : String]()
		
		for (key, value) in formValues {
			store[key] = value as? String ?? ""
		}
		
		store[Constants.StoreKey.website] = Utilities().castUrlToString(formValues[Constants.StoreKey.website] ?? "")
		store[Constants.StoreKey.timetableOpen] = Utilities().formatDateToHourMinute( formValues[Constants.StoreKey.timetableOpen] as! Date )
		store[Constants.StoreKey.timetableClose] = Utilities().formatDateToHourMinute( formValues[Constants.StoreKey.timetableClose] as! Date )
		
		return store
	}
	
	
	func addStoreToFirebaseDatabase(_ storeData : [String : String]){
		dbRef.child("store").childByAutoId().setValue(storeData) { (err, databaseReference) in
			if err != nil {
				Utilities().showAlert(title: "Error", message: "Please check if you have an active internet connection and try again", viewController: self, actionTitle: "Dismiss", actionStyle: .cancel)
			} else {
				Utilities().showAlert(title: "Succes", message: "Store added", viewController: self, actionTitle: "OK", actionStyle: .default)
				// TODO: Perform segue to MapViewController
			}
		}
	}
	
	
	private func processGeocoderResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) -> CLLocationCoordinate2D? {
		if error == nil {
			var location: CLLocation?
			
			if let placemarks = placemarks, placemarks.count > 0 {
				location = placemarks.first?.location
			}
			
			if let location = location {
				return location.coordinate
			}
		}
		return nil
	}

	func createForm() {
		form
			+++ Section("Store details")
			<<< NameRow() { row in
				row.title = Constants.StoreKey.name
				row.tag = Constants.StoreKey.name
				row.add(rule: RuleRequired())
				row.cellUpdate({ (cell, row) in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
						row.placeholder = "required"
					}
				})
			}
			
			<<< TextRow() { row in
				row.title = Constants.StoreKey.street
				row.tag = Constants.StoreKey.street
				row.add(rule: RuleRequired())
				row.cellUpdate({ (cell, row) in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
						row.placeholder = "required"
					}
				})
			}
			
			<<< TextRow() { row in
				row.title = Constants.StoreKey.city
				row.tag = Constants.StoreKey.city
				row.add(rule: RuleRequired())
				row.cellUpdate({ (cell, row) in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
						row.placeholder = "required"
					}
				})
			}
			
			+++ Section(Constants.StoreKey.timetable)
			<<< TimeRow() { row in
				row.title = Constants.StoreKey.timetableOpen
				row.tag = Constants.StoreKey.timetableOpen
				row.value = Date.init(timeIntervalSinceReferenceDate: (60*60*17))
			}
			<<< TimeRow() { row in
				row.title = Constants.StoreKey.timetableClose
				row.tag = Constants.StoreKey.timetableClose
				row.value = Date.init(timeIntervalSinceReferenceDate: (60*60))
			}
			+++ Section("Additional information")
			
			<<< URLRow() { row in
				row.placeholder = Constants.StoreKey.website
				row.tag = Constants.StoreKey.website
				row.add(rule: RuleURL())
				row.cellUpdate({ (cell, row) in
					if !row.isValid {
						cell.textField.text = ""
						row.placeholder = "Leave empty or enter a valid url"
					}
				})
			}
		
			<<< PhoneRow() { row in
				row.placeholder = Constants.StoreKey.telephone
				row.tag = Constants.StoreKey.telephone
			}
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
