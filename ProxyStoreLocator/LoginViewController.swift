//
//  LoginViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 16/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

	@IBOutlet weak var emailTextFiled: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var loginButton: UIButton!
	
	@IBAction func forgotPasswordButtonTapped() {
		sendEmailToResetPassword()
	}
	
	@IBAction func loginButtonTapped() {
		loginButton.isEnabled = false
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		loginUserWithEmailPassword()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		activityIndicator.isHidden = true
		loginButton.isEnabled = true
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func loginUserWithEmailPassword() {
		//TODO : verify data
		let email = emailTextFiled.text!
		let password = passwordTextField.text!
		
		Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
			self.loginButton.isEnabled = true
			self.activityIndicator.stopAnimating()
			self.activityIndicator.isHidden = true
			
			if err != nil {
				Utilities().showAlert(title: "Error", message: "Wrong email and/or password", viewController: self, actionTitle: "Dissmiss", actionStyle: .cancel)
			}
			if let user = user {
				Utilities().showAlertWithSegueToPerform(title: "Welcome back", message: "\(String(describing: user.displayName!))", viewController: self, actionTitle: Constants.MenuItems.map, actionStyle: .default, segueIdentifier: "unWindToMap")
			}
		}
		
	}
	
	func sendEmailToResetPassword() {
		let alert = UIAlertController(title: "Reset Password", message: "Please provide your email address.", preferredStyle: .alert)
		
		alert.addTextField { (forgotPasswordEmailTextField) in
			forgotPasswordEmailTextField.keyboardType = .emailAddress
			if let emailText = self.emailTextFiled.text {
				if (!emailText.isEmpty) {
					forgotPasswordEmailTextField.text = emailText
				}
			}
		}
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
			if let email = alert.textFields![0].text {
				Auth.auth().sendPasswordReset(withEmail: email, completion: { (err) in
					if err != nil {
						Utilities().showAlert(title: "Error", message: "Invalid email", viewController: self, actionTitle: "Dismiss", actionStyle: .cancel)
					} else {
						Utilities().showAlert(title: "Succes", message: "Please check your email for a password reset link", viewController: self, actionTitle: "OK", actionStyle: .default)
					}
				})
			}
			
		}))
		
		self.present(alert, animated: true, completion: nil)
		
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
