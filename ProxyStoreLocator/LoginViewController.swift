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
	
	@IBAction func loginButtonTapped() {
		loginUserWithEmailPassword()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
			if let err = err {
				print(err.localizedDescription)
			}
			if let user = user {
				print("username : \(String(describing: user.displayName)) \n email : \(String(describing: user.email)) \n userid : \(user.uid)")
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
