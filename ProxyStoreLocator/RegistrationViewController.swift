//
//  RegistrationViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 16/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit
import Eureka
import FirebaseAuth
import FirebaseDatabase

class RegistrationViewController: FormViewController {

	@IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
		signUpUserWithEmailPassword()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		createForm()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	func createForm() {
		form
			+++ Section("User")
			<<< AccountRow() { row in
				row.placeholder = Constants.UserKey.username
				row.tag = Constants.UserKey.username
			}
			<<< EmailRow() { row in
				row.placeholder = Constants.UserKey.email
				row.tag = Constants.UserKey.email
			}
			
			+++ Section("Password")
			<<< PasswordRow() { row in
				row.placeholder = Constants.UserKey.password
				row.tag = Constants.UserKey.password
			}
			<<< PasswordRow() { row in
				row.placeholder = Constants.UserKey.repeatPassword
				row.tag = Constants.UserKey.repeatPassword
			}
	}
	
	func signUpUserWithEmailPassword() {
		var formValues = form.values()
		let email = formValues[Constants.UserKey.email] as! String
		let password = formValues[Constants.UserKey.password] as! String
		let username = formValues[Constants.UserKey.username] as! String
		
		Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
			if let err = err {
				print(err.localizedDescription)
			} else {
				let updateReq = user?.createProfileChangeRequest()
				updateReq?.displayName = username
				updateReq?.commitChanges(completion: { (err) in
					if let err = err {
						print(err.localizedDescription)
					} else {
						print("username update succesful")
						print(user!.displayName!)
					}
				})
			}
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
