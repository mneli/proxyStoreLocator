//
//  FavoritesTableViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 06/11/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FavoritesTableViewController: UITableViewController {
	
	var arrOfFavorites = [Store](){
		didSet {
			if (arrOfFavorites.count == nbOfFavoriteStores){
				tableView.reloadData()
			}
		}
	}
	var nbOfFavoriteStores = 0
	var storeDbRef = Database.database().reference().child(Constants.FirebaseKey.Stores)
	var currentUserFavDBRef = Database.database().reference().child(Constants.FirebaseKey.Users).child(Auth.auth().currentUser!.uid).child(Constants.FirebaseKey.UserFavorites)
	
	override func viewDidLoad() {
        super.viewDidLoad()
		loadFavorites()
		
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is StoreDetailsViewController {
			if let destinationVC = segue.destination as? StoreDetailsViewController, let store = sender as? Store {
				destinationVC.store = store
			}
		}
	}
	
	func loadFavorites() {
		currentUserFavDBRef.observeSingleEvent(of: .value) { (dataSnapshot) in
			if let favoriteStoreIdsDictionary = dataSnapshot.value as? Dictionary<String, String> {
				let keys = Array(favoriteStoreIdsDictionary.keys)
				self.nbOfFavoriteStores = keys.count
				for dbStoreId in keys {
					self.storeDbRef.child(dbStoreId).observeSingleEvent(of: .value) { (storeSnapshot) in
						if let storeData = storeSnapshot.value as? Dictionary<String, String> {
							self.arrOfFavorites.append(Store(storeSnapshot.key, storeData))
						}
					}
				}
			}
		}
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
		cell.imageView?.image = UIImage(named: "favorite-icon")
		cell.accessoryType = .detailDisclosureButton
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: "StoreDetailsSegue", sender: arrOfFavorites[indexPath.row])
	}
	
	override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		self.performSegue(withIdentifier: "StoreDetailsSegue", sender: arrOfFavorites[indexPath.row])
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
			currentUserFavDBRef.child(arrOfFavorites[indexPath.row].dbId).removeValue(completionBlock: { (err, dbref) in
				if err == nil {
					self.arrOfFavorites.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .fade)
				}
			})
        }
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
