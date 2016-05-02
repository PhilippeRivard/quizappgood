//
//  WelcomePageVC.swift
//  NotSureIfThisWorks
//
//  Created by Philippe Rivard on 1/12/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit

class StartUpPageVC: UIViewController {
    
    var signedIn:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataService.ds.REF_BASE.authData == nil {
            print("nigger")
            let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "signOut", userInfo: nil, repeats: false)
        }
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey("IsLoggedIn"){
            
               // DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("online").setValue(true)
            

            let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "loggedIn", userInfo: nil, repeats: false)
        }
        else if (NSUserDefaults.standardUserDefaults().boolForKey("needsVerification")){
            let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "loggedIn", userInfo: nil, repeats: false)
        }
        else {
            let timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "notLoggedIn", userInfo: nil, repeats: false)
        }
        
    }
    
    func notLoggedIn() {
        self.performSegueWithIdentifier("SignUpOrSignInVC", sender: self)
    }
    
    func loggedIn() {
        self.performSegueWithIdentifier("HomePageVC", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signOut() {
        performSegueWithIdentifier("SignUpOrSignInVC", sender: nil)
    }
    
}
