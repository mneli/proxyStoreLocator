//
//  StoreDetailsViewController.swift
//  ProxyStoreLocator
//
//  Created by November Mike on 22/10/2017.
//  Copyright © 2017 mneli. All rights reserved.
//

import UIKit

class StoreDetailsViewController: UIViewController {
	
	var store: Store! = nil
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print(store.fullAddress())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
