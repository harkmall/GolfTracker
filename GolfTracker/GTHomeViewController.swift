//
//  GTHomeViewController.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-01-28.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit

class GTHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    @IBAction func getStats(_ sender: Any) {
        GTNetworkingManager.sharedManager.getOverallStats { (response) in
            if let errorMessage = response["error"].string{
                print(errorMessage)
            }
            else{
                print(response)
            }
        }
    }
}
