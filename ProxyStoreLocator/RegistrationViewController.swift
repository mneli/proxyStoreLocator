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
		if(form.validate().isEmpty) {
			signUpUserWithEmailPassword()
		} else {
			print(form.validate())
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		createForm()
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
				Utilities().showAlert(title: "Error", message: "Please try again", viewController: self, actionTitle: "Dismiss", actionStyle: .cancel)
			} else {
				let updateReq = user?.createProfileChangeRequest()
				updateReq?.displayName = username
				updateReq?.commitChanges(completion: { (err) in
					if err != nil {
						Utilities().showAlert(title: "Error server", message: "Your username toudn't be added to the database, you should update it later via your profile page", viewController: self, actionTitle: "Dissmiss", actionStyle: .default)
					} else {
						Utilities().showAlert(title: "Succes", message: "Account created successfully", viewController: self, actionTitle: "OK", actionStyle: .default)
						// TODO: perform segue to map
					}
				})
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
						cell.textField.text = ""
						row.placeholder = "Provide a valid email"
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
						cell.textField.text = ""
						row.placeholder = "Enter password: min 6 character"
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
						cell.textField.text = ""
						row.placeholder = "Password should match"
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
