//
//  UIStoryboardSegueWithCompletion.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 18/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit


class UIStoryboardSegueWithCompletion: UIStoryboardSegue {
	var completion: (() -> Void)?
	
	override func perform() {
		super.perform()
		if let completion = completion {
			completion()
		}
	}
}
