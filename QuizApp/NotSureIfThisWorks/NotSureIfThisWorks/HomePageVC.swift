//
//  HomePageVC.swift
//  NotSureIfThisWorks
//
//  Created by Philippe Rivard on 1/12/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit

class HomePageVC: UIViewController {
    var uid: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignOutBtnPressed(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "IsLoggedIn")
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "UserEmail")
        performSegueWithIdentifier("SignUpOrSignInVC", sender: nil)
    }
    
    @IBAction func onPlayBtnPressed(sender: AnyObject) {
     //   DataService.ds.REF_BASE.childByAppendingPath("users").childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("online").setValue(true)
        performSegueWithIdentifier("SelectOpponentVC", sender: nil)
        
    }
    
    
}
