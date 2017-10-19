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

class AddStoreViewController: FormViewController {

	var dbRef: DatabaseReference!
	var dbRefHandle: DatabaseHandle!
	
	@IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
		addStoreToFirebaseDatabase(formatDataForFirebase())
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
	
	func createForm() {
		form
		+++ Section("Store details")
			<<< NameRow() { row in
				row.placeholder = Constants.StoreKeys.name
				row.tag = Constants.StoreKeys.name
			}
			<<< TextRow() { row in
				row.placeholder = Constants.StoreKeys.street
				row.tag = Constants.StoreKeys.street
			}
			<<< TextRow() { row in
				row.placeholder = Constants.StoreKeys.city
				row.tag = Constants.StoreKeys.city
			}
			
		+++ Section(Constants.StoreKeys.timetable)
			<<< TimeRow() { row in
				row.title = Constants.StoreKeys.timetableOpen
				row.tag = Constants.StoreKeys.timetableOpen
				row.value = Date.init(timeIntervalSinceReferenceDate: (60*60*17))
			}
			<<< TimeRow() { row in
				row.title = Constants.StoreKeys.timetableClose
				row.tag = Constants.StoreKeys.timetableClose
				row.value = Date.init(timeIntervalSinceReferenceDate: (60*60))
			}
		+++ Section("Additional information")
			<<< PhoneRow() { row in
				row.placeholder = Constants.StoreKeys.telephone
				row.tag = Constants.StoreKeys.telephone
			}
			<<< URLRow() { row in
				row.placeholder = Constants.StoreKeys.website
				row.tag = Constants.StoreKeys.website
			}
	}
	
	func formatDataForFirebase() -> [String : String] {
		//TODO : reformat this noob data treatment
		let formValues = form.values()
		var store = [String : String]()
		
		for (key, value) in formValues {
			store[key] = value as? String ?? ""
		}
		
		store[Constants.StoreKeys.website] = castUrlToString(formValues[Constants.StoreKeys.website])
		store[Constants.StoreKeys.timetableOpen] = formatDateToHourMinute( formValues[Constants.StoreKeys.timetableOpen] as! Date )
		store[Constants.StoreKeys.timetableClose] = formatDateToHourMinute( formValues[Constants.StoreKeys.timetableClose] as! Date )
		
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
	
	func addStoreToFirebaseDatabase(_ storeData : [String : String]){
		dbRef.child("store").childByAutoId().setValue(storeData)
//		dbRef.child("user").setValue(["something" : ["keyOfSomething" : "valueOfSomething"]])
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
