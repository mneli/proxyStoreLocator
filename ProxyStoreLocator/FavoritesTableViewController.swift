//
//  FavoritesTableViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 06/11/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {

//	let cell: UITableViewCell =
//		tableView.dequeueResuableCell(withIdentifier: "Favorite", for:
//			indexPath)
	
	var arrOfFavorites = [Store]()
	
	
	@IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
		let tableViewEditingMode = tableView.isEditing
		tableView.setEditing(!tableViewEditingMode, animated: true)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()

		let store1 = Store(name: "Test list Store", street: "Street 1", city: "Brussels", openingTime: "18:00", closingTime: "22:00", telephone: "", website: "", coordinatesLat: "50", coordinatesLong: "4")
		
		
		let store2 = Store(name: "Test list Store 2", street: "Street 2", city: "Brussels", openingTime: "18:00", closingTime: "22:00", telephone: "", website: "", coordinatesLat: "50", coordinatesLong: "4")
		
		arrOfFavorites.append(store1)
		arrOfFavorites.append(store2)
		
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? arrOfFavorites.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
		cell.textLabel?.text = arrOfFavorites[indexPath.row].name
        cell.detailTextLabel?.text = arrOfFavorites[indexPath.row].fullAddress()
		cell.imageView?.image = UIImage(named: "pin-icon")
		cell.accessoryType = .detailDisclosureButton
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("\(arrOfFavorites[indexPath.row].name) selected")
	}
	
	override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		print("\(arrOfFavorites[indexPath.row].name) selected")
	}
	
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		return .delete
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

	
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
			arrOfFavorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
//		else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
