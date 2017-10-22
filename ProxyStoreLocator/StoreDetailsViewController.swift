//
//  StoreDetailsViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 22/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit
import MapKit

class StoreDetailsViewController: UIViewController {
	
	var store: Store! = nil
	
	@IBOutlet weak var storeNameLabel: UILabel!
	@IBOutlet weak var storeTimeTableLabel: UILabel!
	@IBOutlet weak var storeTelephoneLabel: UILabel!
	@IBOutlet weak var storeWebsiteLabel: UILabel!
	@IBOutlet weak var storeAddressLabel: UILabel!
	
	@IBAction func navigateButtonTapped() {
		 self.mapItem().openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
	}
	
	func mapItem() -> MKMapItem {
		
		let placemark = MKPlacemark(coordinate: store.coordinate)
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = store.title
		
		return mapItem
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		populateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func populateLabels() {
		storeNameLabel.text = store.name
		storeTimeTableLabel.text = "Timetable : \(store.openingTime)-\(store.closingTime)"
		if store.telephone != "" {
			storeTelephoneLabel.text = store.telephone
		}
		if store.website?.absoluteString != "" {
			storeWebsiteLabel.text = store.website?.absoluteString
		}
		storeAddressLabel.text = store.fullAddress()
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
