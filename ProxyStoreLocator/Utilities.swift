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
	
	func showAlertWithSegueToPerform(title: String, message: String, viewController: UIViewController, actionTitle: String, actionStyle: UIAlertActionStyle, segueIdentifier: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: actionTitle, style: actionStyle, handler: { (action) in
			viewController.performSegue(withIdentifier: segueIdentifier, sender: nil)
		}))
		viewController.present(alert, animated: true, completion: nil)
	}
	
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
	
}
