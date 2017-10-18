//
//  MenuViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 16/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

	var buttonIdentifier : Int!
	
	var choosenOption: String = Constants.MenuItems.map
	
	@IBOutlet weak var mapButton: UIButton!
	@IBOutlet weak var profileButton: UIButton!
	@IBOutlet weak var favoritesButton: UIButton!
	@IBOutlet weak var addStoreButton: UIButton!
	@IBOutlet weak var aboutButton: UIButton!
	
	@IBAction func menuOptionTapped(_ sender: UIButton) {
		self.choosenOption = sender.title(for: .normal)!
		self.performSegue(withIdentifier: "unwindToMap", sender: choosenOption)
//		self.dismiss(animated: true) {
//			print("menu dismissed")
//			
//		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setMenuButtonTitles()
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
	}
	
	func setMenuButtonTitles() {
		mapButton.setTitle(Constants.MenuItems.map, for: .normal)
		profileButton.setTitle(Constants.MenuItems.profile, for: .normal)
		favoritesButton.setTitle(Constants.MenuItems.favorites, for: .normal)
		addStoreButton.setTitle(Constants.MenuItems.addStore, for: .normal)
		aboutButton.setTitle(Constants.MenuItems.about, for: .normal)
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
