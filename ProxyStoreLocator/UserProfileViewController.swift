//
//  UserProfileViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 18/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserProfileViewController: UIViewController {

	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var userEmailLabel: UILabel!
	
	
	@IBAction func logoutButtonTapped() {
		do {
			try Auth.auth().signOut()
		} catch let signOutError as NSError {
			print(signOutError.localizedDescription)
		}
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		populateLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func populateLabel() {
		if( isUserLoggedIn() ){
			usernameLabel.text = Auth.auth().currentUser?.displayName
			userEmailLabel.text = Auth.auth().currentUser?.email
		} else {
			logoutButtonTapped()
		}
	}
	
	func isUserLoggedIn() -> Bool {
		return (Auth.auth().currentUser == nil) ? false : true
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
