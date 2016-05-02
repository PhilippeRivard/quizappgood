//
//  SelectOpponentVC.swift
//  NotSureIfThisWorks
//
//  Created by Oli Eydt on 2016-01-18.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation

class SelectOpponentVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var keyboardHeightLayoutConstraint2: NSLayoutConstraint!
    
    
    
    
    var player2: String?
    var tempBool: Bool = true
    weak var timer : NSTimer?
    weak var constantTimer: NSTimer?
    var isHost: Bool!
    var hostName: String?
    
    var universities = [University]()
    var filteredUniversities = [University]()
    var chosenUniversity: University!
    var inSearchMode = true
    var tableViewBottomConstraint: CGFloat?
    
    var university: University!
    
    var hostSchool: String?
    
    var inQueue = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        parseUniversitiesCSV()
        
        //searchButton.enabled = false
        
     



        DataService.ds.REF_USERS.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.hostSchool = snapshot.childSnapshotForPath(DataService.ds.REF_BASE.authData.uid).childSnapshotForPath("schoolName").value as? String
            print(self.hostSchool)
        })
        
       // DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("online").setValue(true)
        
       // DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("newMessage").observeEventType(.Value, withBlock: { snapshot in
            //if snapshot.value as? Bool == true {
          //      self.mailImg.hidden = false
         //   }
          //  else {
           //     self.mailImg.hidden = true
          //  }
      //  })
        
       // timer = NSTimer.scheduledTimerWithTimeInterval(12, target: self, selector: "isLoggedIn", userInfo: nil, repeats: false)
        
      //  DataService.ds.REF_USERS.observeEventType(.ChildAdded, withBlock: { snapshot in
          //  if DataService.ds.REF_BASE.authData.uid != snapshot.key {
          //      self.player1Btn.setTitle(snapshot.value.objectForKey("name") as? String, forState: .Normal)
              //  if snapshot.value.objectForKey("online") as? Bool == true {
              //      self.player1OnlineImg.image = UIImage(named: "greendot")
              //  } else{
              //      self.player1OnlineImg.image = UIImage(named: "reddot")
               // }
          //  }
            
       // })
        
        
        
        
        
        
        
        
         //player1Btn.setTitle(NSUserDefaults.standardUserDefaults().stringForKey("UserEmail"), forState: .Normal)
   
        
        //player2Btn.setTitle("oli", forState: .Normal)
        
        /*    DataService.ds.REF_USERS.observeEventType(.ChildAdded, withBlock: { snapshot in
        //print(snapshot.value.objectForKey("online")!)
        //print(snapshot.value.objectForKey("name")!)
        if self.tempBool == true {
        print("gros")
        self.player1Btn.setTitle(snapshot.value.objectForKey("name") as? String, forState: .Normal)
        if snapshot.value.objectForKey("online") as? Bool == true {
        print("gros1")
        self.player1OnlineImg.image = UIImage(named: "greendot")
        }
        else {
        self.player1OnlineImg.image = UIImage(named: "reddot")
        }
        self.tempBool = false
        }
        //STUFF IS NOT UPDATING AUTOMATICALLY IN THE APP WHEN WE DO THIS. THIS IS BECAUSE WE ONLY LOOK FOR IT ONCE
        else if self.tempBool == false {
        print("gros")
        self.player2Btn.setTitle(snapshot.value.objectForKey("name") as? String, forState: .Normal)
        if snapshot.value.objectForKey("online") as? Bool == true {
        self.player2OnlineImg.image = UIImage(named: "greendot")
        print("gros2")
        }
        else {
        self.player2OnlineImg.image = UIImage(named: "reddot")
        }
        }
        
        //DataService.ds.REF_USERS.removeAllObservers()
        
        self.constantTimer = NSTimer.scheduledTimerWithTimeInterval(12, target: self, selector: "isOnlineConstant", userInfo: nil, repeats: true)
        
        
        })
        
        //DataService.ds.REF_USERS.childByAppendingPath("oli").childByAppendingPath("online").observeEventType(.Value, withBlock: { snapshot in
        // if snapshot.value as? Bool == true {
        //    self.player2OnlineImg.image = UIImage(named: "greendot")
        //}
        
        // else {
        //   self.player2OnlineImg.image = UIImage(named: "reddot")
        //}
        
        //}, withCancelBlock: { error in
        //      print(error.description)
        //})
        */
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if inSearchMode {
            university = filteredUniversities[indexPath.row]
        }
        else {
            university = universities[indexPath.row]
        }
        //searchBar.text = university.uniName
        
        //starts here
        DataService.ds.REF_BASE.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.childSnapshotForPath("currentGames").value as? String == nil)
            print(self.inQueue == false)
            if snapshot.childSnapshotForPath("currentGames").value as? String == nil && self.inQueue == false {
                self.inQueue = true
                print("before create game")
                self.createGame()
                print("after create game")
                DataService.ds.REF_BASE.removeAllObservers()
                self.performSegueWithIdentifier("InGameVC", sender: self)
                print("after perform segue")
                
                
            }
        })
        
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").observeEventType(.ChildAdded, withBlock: { snapshot in
           
            if snapshot.childSnapshotForPath("opponent").value as? String == "" && self.inQueue == false && snapshot.childSnapshotForPath("hostSchoolName").value as? String == self.university.uniName && snapshot.childSnapshotForPath("opponentSchool").value as? String == self.hostSchool {
                print("k")
                if (DataService.ds.REF_BASE.authData.uid != snapshot.key) {
                    self.inQueue = true
                    
                    print("nah")
                    //DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("inQueue").setValue(true)
                    
                    
                    self.isHost = false
                    self.hostName = snapshot.key
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(snapshot.key).childByAppendingPath("opponent").setValue(DataService.ds.REF_BASE.authData.uid)
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").removeAllObservers()
                    
                    self.performSegueWithIdentifier("InGameVC", sender: self)
                }
            }
        })
        
        
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").observeEventType(.ChildAdded, withBlock: { snapshot in
            //counter2 += 1
            if self.inQueue == false && snapshot.childSnapshotForPath("opponent").value as? String != "" {
                self.inQueue = true
                
                //counter3 += 1
                //print(counter2)
                
                // if counter3 == counter2 {
                //      print("nig")
                //    self.createGame()
                //  self.performSegueWithIdentifier("InGameVC", sender: nil)
                //DataService.ds.REF_BASE.childByAppendingPath("currentGames").removeAllObservers()
                //}
                self.createGame()
                DataService.ds.REF_BASE.childByAppendingPath("currentGames").removeAllObservers()
                self.performSegueWithIdentifier("InGameVC", sender: self)
                
            }
        })
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("SchoolSearchCell", forIndexPath: indexPath) as? SchoolSearchCell {
            
            let university: University!
            if inSearchMode {
                university = filteredUniversities[indexPath.row]
                print("university.uniname is: " + university.uniName)
                print("searchBar.text is: " + searchBar.text!)
                print(searchBar.text! == university.uniName)
                /*if searchBar.text!.lowercaseString == university.uniName.lowercaseString {
                    print("im in")
                    searchButton.enabled = true
                }
                else {
                    searchButton.enabled = false
                }*/
            }
            else {
                university = universities[indexPath.row]
            }
            cell.configureCell(university)
            return cell
        }
        else {
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredUniversities.count
        }
        return universities.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    //SearchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        inSearchMode = true
        let lower = searchBar.text!.lowercaseString
        filteredUniversities = universities.filter({$0.uniName.lowercaseString.rangeOfString(lower) != nil})
        if searchBar.text == "" || searchBar.text == nil {
            searchBar.resignFirstResponder()
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
        tableView.reloadData()
    }

    
    
  /*  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if timer == nil
        {
            // var tempBool : Bool = true
            DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("online").setValue(true)
            /*if(DataService.ds.REF_BASE.authData.uid == "4dfb52d5-9ed6-449f-9074-ee822148c7ca"){
            player1OnlineImg.image = UIImage(named: "greendot")
            } else{
            //  player2OnlineImg.image = UIImage(named: "greendot")
            }*/
            
            timer = NSTimer.scheduledTimerWithTimeInterval(12, target: self, selector: "isLoggedIn", userInfo: nil, repeats: false)
        } else{
            //  var tempBool : Bool = false
            timer!.invalidate()
            timer = nil
            timer = NSTimer.scheduledTimerWithTimeInterval(12, target: self, selector: "isLoggedIn", userInfo: nil, repeats: false)
            
            
        }
        super.touchesBegan(touches, withEvent:event)
    }*/
    
    /*func isOnlineConstant(){
    self.tempBool = true
    DataService.ds.REF_USERS.removeAllObservers()
    DataService.ds.REF_USERS.observeEventType(.ChildAdded, withBlock: { snapshot in
    
    //print(snapshot.value.objectForKey("online")!)
    //print(snapshot.value.objectForKey("name")!)
    if self.tempBool == true {
    print("gros")
    if snapshot.value.objectForKey("online") as? Bool == true {
    self.player1OnlineImg.image = UIImage(named: "greendot")
    }
    else {
    self.player1OnlineImg.image = UIImage(named: "reddot")
    }
    self.tempBool = false
    }
    //STUFF IS NOT UPDATING AUTOMATICALLY IN THE APP WHEN WE DO THIS. THIS IS BECAUSE WE ONLY LOOK FOR IT ONCE
    else if self.tempBool == false {
    print("gros")
    if snapshot.value.objectForKey("online") as? Bool == true {
    print("gros11")
    self.player2OnlineImg.image = UIImage(named: "greendot")
    }
    else {
    self.player2OnlineImg.image = UIImage(named: "reddot")
    }
    }
    
    })
    }*/
    
    
    func isLoggedIn() {
        //DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("online").setValue(false)
        /*  if(DataService.ds.REF_BASE.authData.uid == "4dfb52d5-9ed6-449f-9074-ee822148c7ca"){
        player1OnlineImg.image = UIImage(named: "reddot")
        } else{
        //  player2OnlineImg.image = UIImage(named: "reddot")
        }*/
    }
    
    func messageRead() {
        DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("newMessage").setValue(false)
        
    }
    
    func parseUniversitiesCSV() {
        let path = NSBundle.mainBundle().pathForResource("UniListUSA", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            
            for row in rows {
                let uniName = row["uni_name"]!
                let uniState = row["uni_state"]!
                let university = University(uniName: uniName, uniState: uniState)
                universities.append(university)
            }
        }
        catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func onPlayer1BtnPressed(sender: AnyObject) {
        
        /*
        DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("inQueue").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value as? Bool == true {
                inQueue = true
            }
            else if snapshot.value as? Bool == false {
                inQueue = false
            }
        
        })

*/
        
        
       
        
        
      
    }
    /*@IBAction func onPlayer2BtnPressed(sender: AnyObject) {
    if DataService.ds.REF_BASE.authData.uid == "cdbc1330-bc3f-4faa-9d4e-369259b2e98f" {
    performSegueWithIdentifier("MyMessagesVC", sender: nil)
    }
    else {
    
    performSegueWithIdentifier("MessageWriteVC", sender: nil)
    }
    }*/
    
    func createGame() {
        DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("inQueue").setValue(true)
        self.isHost = true
        self.hostName = DataService.ds.REF_BASE.authData.uid
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("opponent").setValue("")
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("questionRandNumber").setValue("")
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("myScore").setValue("0")
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("opponentScore").setValue("0")
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("opponentSchool").setValue(university.uniName)
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("hostSchoolName").setValue(hostSchool)
        
        
        
        
        
    }
    
    @IBAction func onBackBtnPressed(sender: AnyObject) {
     //   DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("online").setValue(false)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InGameVC" {
            if let InGameVC = segue.destinationViewController as? InGameVC {
                InGameVC.isHost = isHost
                InGameVC.hostName = hostName
            }
        }
    }
    
    @IBAction func onSearchButtonPressed(sender: AnyObject) {
    }
    
    
}