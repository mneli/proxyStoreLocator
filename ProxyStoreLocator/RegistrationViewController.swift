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
	
	var dbRef: DatabaseReference!

	@IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
		if(form.validate().isEmpty) {
			signUpUserWithEmailPassword()
		} else {
			Utilities().showAlert(title: "Error",
			                      message: "Please complete the required fields",
			                      viewController: self, actionTitle: "Dissmiss",
			                      actionStyle: .cancel)
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
	
	func signUpUserWithEmailPassword() {
		var formValues = form.values()
		let email = formValues[Constants.UserKey.email] as! String
		let password = formValues[Constants.UserKey.password] as! String
		let username = formValues[Constants.UserKey.username] as! String
		
		Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
			if err != nil {
				Utilities().showAlert(title: "Error",
				                      message: "Please try again",
				                      viewController: self, actionTitle: "Dismiss",
				                      actionStyle: .cancel)
			} else if let user = user {
				
				let updateReq = user.createProfileChangeRequest()
				updateReq.displayName = username
				updateReq.commitChanges(completion: { (err) in
					if err != nil {
						Utilities().showAlert(title: "Error server",
						                      message: "Your username coudn't be added to the database, you should update it later via your profile page",
						                      viewController: self, actionTitle: "Dissmiss",
						                      actionStyle: .default)
					} else {
						self.dbRef.child("users").child(user.uid).setValue(username)
						Utilities().showAlertWithSegueToPerform(title: "Succes",
						                                        message: "Welcome \(username)",
						                                        viewController: self,
						                                        actionTitle: "Home",
						                                        actionStyle: .default,
						                                        segueIdentifier: "unWindToMap")
					}
				})
				
			}
		}
	}
	
	func addStoreToFirebaseDatabase(_ storeData : [String : String]){
		dbRef.child("user").childByAutoId().setValue(storeData) { (err, databaseReference) in
			if err != nil {
				Utilities().showAlert(title: "Error", message: "Please check if you have an active internet connection and try again", viewController: self, actionTitle: "Dismiss", actionStyle: .cancel)
			} else {
				//				Utilities().showAlert(title: "Succes", message: "Store added", viewController: self, actionTitle: "OK", actionStyle: .default)
				Utilities().showAlertWithSegueToPerform(title: "Succes", message: "Store added", viewController: self, actionTitle: "Home", actionStyle: .default, segueIdentifier: "unWindToMap")
			}
		}
	}
	
	func createForm() {
		form
			+++ Section("User")
			<<< AccountRow() { row in
				row.placeholder = Constants.UserKey.username
				row.tag = Constants.UserKey.username
				row.add(rule: RuleRequired())
				row.cellUpdate({ (cell, row) in
					if !row.isValid {
						row.placeholder = "Username required"
					}
				})
			}
			<<< EmailRow() { row in
				row.placeholder = Constants.UserKey.email
				row.tag = Constants.UserKey.email
				row.add(rule: RuleRequired())
				row.add(rule: RuleEmail())
				row.cellUpdate({ (cell, row) in
					if !row.isValid {
						cell.backgroundColor = .red	
					}
				})
			}
			
			+++ Section("Password")
			<<< PasswordRow() { row in
				row.placeholder = Constants.UserKey.password
				row.tag = Constants.UserKey.password
				row.add(rule: RuleRequired())
				row.add(rule: RuleMinLength(minLength: 6))
				row.cellUpdate({ (cell, row) in
					if !row.isValid {
						cell.backgroundColor = .red
					}
				})
				
			}
			<<< PasswordRow() { row in
				row.placeholder = Constants.UserKey.repeatPassword
				row.tag = Constants.UserKey.repeatPassword
				row.add(rule: RuleRequired())
				row.add(rule: RuleMinLength(minLength: 6))
				let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
					let passwordRow: PasswordRow? = self.form.rowBy(tag: Constants.UserKey.password)
					let passwordValue = passwordRow?.value
					return (rowValue == nil || rowValue!.isEmpty || rowValue != passwordValue) ? ValidationError(msg: "not valid password") : nil
				}
				row.add(rule: ruleRequiredViaClosure)
				row.cellUpdate({ (cell, row) in
					if !row.isValid {
						cell.backgroundColor = .red
					}
				})
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
