//
//  Utilities.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 23/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
	
	func showAlert(title: String, message: String, viewController: UIViewController, actionTitle: String, actionStyle: UIAlertActionStyle) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: nil))
		viewController.present(alert, animated: true, completion: nil)
	}

}
