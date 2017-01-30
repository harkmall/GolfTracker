//
//  GTCourseSearchViewController.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-01-29.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit

class GTCourseSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
