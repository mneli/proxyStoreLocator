//
//  Constants.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 17/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import Foundation

struct Constants {
	struct MenuItems {
		static let map = "Map"
		static let profile = "Profile"
		static let favorites = "Favorites"
		static let addStore = "Add Store"
		static let about = "About"
	}
	struct StoreKey {
		static let name = "Name"
		static let street = "Street"
		static let city = "City"
		static let timetable = "Timetable"
		static let timetableOpen = "Open"
		static let timetableClose = "Close"
		static let telephone = "Telephone"
		static let website = "Website"
		static let cLatitude = "coordinateLatitude"
		static let cLongitude = "coordinateLongitude"
	}
	struct UserKey {
		static let username = "username"
		static let email = "email"
		static let password = "password"
		static let repeatPassword = "repeat password"
	}
	struct FirebaseKey {
		static let Stores = "stores"
		static let Users = "users"
		static let UserFavorites = "favorites"
	}
}
