//
//  Store.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 21/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import Foundation
import MapKit

class Store: NSObject, MKAnnotation {
	
	let name: String
	let street: String
	let city: String
	let openingTime: String
	let closingTime: String
	let telephone: String?
	let website: URL?
	let coordinatesLat: Double
	let coordinatesLong: Double
	
	
	var title: String? {
		return self.name
	}
	var subtitle: String? {
		return self.fullAddress()
	}
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2DMake(self.coordinatesLat, self.coordinatesLong)
	}
	
	init(name: String, street: String, city: String, openingTime: String,
	     closingTime: String, telephone: String, website: String,
	     coordinatesLat: String, coordinatesLong: String) {
		
		self.name = name
		self.street = street
		self.city = city
		self.openingTime = openingTime
		self.closingTime = closingTime
		self.telephone = telephone
		self.website = URL(string: website)
		self.coordinatesLat = Double(coordinatesLat)!
		self.coordinatesLong = Double(coordinatesLong)!
		
		super.init()
	}
	
	func fullAddress() -> String {
		return "\(self.street), \(self.city)"
	}
	
	
}
