//
//  ViewController.swift
//  GolfTracker
//
//  Created by Mark Hall on 2017-01-28.
//  Copyright © 2017 markhall. All rights reserved.
//

import UIKit
import SwiftyJSON

let GTUserToken = "userToken"

class GTLoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        GTNetworkingManager.sharedManager.signUp(username: usernameField.text!, password: password.text!) { (response) in
            
            if let errorMessage = response["error"].string{
                print(errorMessage)
            }
            else{
                self.saveUserInfo(info: response)
                self.performSegue(withIdentifier: "GTShowHome", sender: self)
            }
        }
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        GTNetworkingManager.sharedManager.login(username: usernameField.text!, password: password.text!) { (response) in
            
            if let errorMessage = response["error"].string{
                print(errorMessage)
            }
            else{
                self.saveUserInfo(info: response)
                self.performSegue(withIdentifier: "GTShowHome", sender: self)
            }
        }
    }
    
    func saveUserInfo(info:JSON){
        /*
         {
             "token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjU4NjMwMTMwYjI4ZGIyMDlkZGMzZTczZiIsImlhdCI6MTQ4NTY0MjYyMSwiZXhwIjoxMjAxNDg1NjQyNjIxfQ.3sNAuCdlrt26T5KS7dACEoYqd5vgguZ9yNHn1LiPqcc",
             "user" : {
                 "__v" : 10,
                 "_id" : "58630130b28db209ddc3e73f",
                 "Email" : "golfguru@icloud.com",
                 "Password" : "$2a$10$ehk.XxAQ9SX4lA5ejRe0ouVLLHxcJwO29ThnCSqv5axqgNjxctMuO",
                 "Stats" : [
                 "58802b1ac3586754cfb33542"
                 ]
                 }
         }
         */
        if let tokenString = info["token"].string {
            UserDefaults.standard.set(tokenString, forKey: GTUserToken)
        }
    }
}

