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
	var dbRefHandle: DatabaseHandle!
	lazy var geocoder = CLGeocoder()
	
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		var dataForFirebase = formatDataForFirebase()
		
		let address = "\(dataForFirebase[Constants.StoreKey.street]!), \(dataForFirebase[Constants.StoreKey.city]!)"
		
		geocoder.geocodeAddressString(address) { (placemarks, error) in
			let coordinates = self.processResponse(withPlacemarks: placemarks, error: error)
			if (coordinates != nil){
				dataForFirebase[Constants.StoreKey.cLatitude] = "\(coordinates!.latitude)"
				dataForFirebase[Constants.StoreKey.cLongitude] = String(describing: coordinates!.latitude)
			}
			self.addStoreToFirebaseDatabase(dataForFirebase)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		createForm()
		dbRef = Database.database().reference()
		//setupFirebaseDatabaseListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	deinit {
		//dbRef.child("stores").removeObserver(withHandle: dbRefHandle)
		print("STORE listener removed")
	}
	
	
	
	func formatDataForFirebase() -> [String : String] {
		//TODO : reformat this noob data treatment
		let formValues = form.values()
		var store = [String : String]()
		
		for (key, value) in formValues {
			store[key] = value as? String ?? ""
		}
		
		store[Constants.StoreKey.website] = castUrlToString(formValues[Constants.StoreKey.website])
		store[Constants.StoreKey.timetableOpen] = formatDateToHourMinute( formValues[Constants.StoreKey.timetableOpen] as! Date )
		store[Constants.StoreKey.timetableClose] = formatDateToHourMinute( formValues[Constants.StoreKey.timetableClose] as! Date )
		
		return store
	}
	
	//TODO : move to utilities
	func formatDateToHourMinute(_ date : Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		
		return formatter.string(from: date)
	}
	
	func castUrlToString(_ url : Any?) -> String {
		if let url = url as? URL {
			return url.absoluteString
		}
		return ""
	}
	
	func setupFirebaseDatabaseListener() {
		dbRef = Database.database().reference()
		dbRefHandle = dbRef.child("stores").observe(DataEventType.childAdded, with: { (dataSnapshot) in
			print("something was added to db")
			print(dataSnapshot)
		})
	}
	
	//TODO : if err popup and dont perform segue else perform segue
	func addStoreToFirebaseDatabase(_ storeData : [String : String]){
		dbRef.child("store").childByAutoId().setValue(storeData) { (err, databaseReference) in
			if let err = err {
				print(err.localizedDescription)
			} else {
			print(databaseReference)
			}
		}
//		dbRef.child("user").setValue(["something" : ["keyOfSomething" : "valueOfSomething"]])
	}
	
	
	private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) -> CLLocationCoordinate2D? {
		
		if let error = error {
			print("Unable to Forward Geocode Address \(error)")
		} else {
			var location: CLLocation?
			
			if let placemarks = placemarks, placemarks.count > 0 {
				location = placemarks.first?.location
			}
			
			if let location = location {
				return location.coordinate
			} else {
				print("No Matching Location Found")
			}
		}
		return nil
	}

	func createForm() {
		form
			+++ Section("Store details")
			<<< NameRow() { row in
				row.placeholder = Constants.StoreKey.name
				row.tag = Constants.StoreKey.name
			}
			<<< TextRow() { row in
				row.placeholder = Constants.StoreKey.street
				row.tag = Constants.StoreKey.street
			}
			<<< TextRow() { row in
				row.placeholder = Constants.StoreKey.city
				row.tag = Constants.StoreKey.city
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
			<<< PhoneRow() { row in
				row.placeholder = Constants.StoreKey.telephone
				row.tag = Constants.StoreKey.telephone
			}
			<<< URLRow() { row in
				row.placeholder = Constants.StoreKey.website
				row.tag = Constants.StoreKey.website
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
