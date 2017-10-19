//
//  AddStoreViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 18/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddStoreViewController: UIViewController {

	var dbRef: DatabaseReference!
	var dbRefHandle: DatabaseHandle!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		//dbRef = Database.database().reference()
		//setupFirebaseDatabaseListener()
		//addStoreToFirebaseDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	deinit {
		//dbRef.child("stores").removeObserver(withHandle: dbRefHandle)
		print("STORE listener removed")
	}
	
	func setupFirebaseDatabaseListener() {
		dbRef = Database.database().reference()
		dbRefHandle = dbRef.child("stores").observe(DataEventType.childAdded, with: { (dataSnapshot) in
			print("something was added to db")
			print(dataSnapshot)
		})
	}
	
	func addStoreToFirebaseDatabase(){
		dbRef.child("stores").childByAutoId().setValue(["key" : "value", "key2" : "value2"])
		dbRef.child("user").setValue(["something" : ["keyOfSomething" : "valueOfSomething"]])
		
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
