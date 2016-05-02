//
//  InGameVC.swift
//  NotSureIfThisWorks
//
//  Created by Philippe Rivard on 1/27/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit

class InGameVC: UIViewController {
    
    @IBOutlet weak var meLabel: UILabel!
    
    @IBOutlet weak var opponentLabel: UILabel!

    @IBOutlet weak var aButton: UIButton!
    
    @IBOutlet weak var bButton: UIButton!
    
    @IBOutlet weak var cButton: UIButton!
    
    @IBOutlet weak var dButton: UIButton!
    
    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet weak var myScoreLabel: UILabel!
    
    @IBOutlet weak var outcomeLabel: UILabel!
    
    @IBOutlet weak var searchingForOpponentLabel: UILabel!
    
    
    
    
    @IBOutlet weak var opponentScoreLabel: UILabel!
    var questionArray = [Question]()
    var myScore = 0
    var numberOfQuestions = 0
    var rand: Int?
    var isHost: Bool?
    var hostName: String?
    var questionNumberOfficial: Int?
    var gameCreated = false
    var wins: Int?
    var losses: Int?
    
    var university: University!
    
    weak var timer: NSTimer?
    override func viewDidLoad() {
        super.viewDidLoad()
        parseQuestionsCSV()
        searchingForOpponentLabel.hidden = false
        aButton.hidden = true
        bButton.hidden = true
        cButton.hidden = true
        dButton.hidden = true
        questionTextView.hidden = true
        myScoreLabel.hidden = true
        opponentScoreLabel.hidden = true
        meLabel.hidden = true
        opponentLabel.hidden = true
        outcomeLabel.hidden = true
        print("queerbait")
        
        //wins variable is given value
        DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            print("in wins")
           
                self.wins = snapshot.childSnapshotForPath("wins").value as? Int
                print(self.wins!)
            
        })
        
        //losses variable is given value
        DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.losses = snapshot.childSnapshotForPath("losses").value as? Int
        })
        
        
        
        
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).childByAppendingPath("questionRandNumber").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value as? String != "" || snapshot.value as? String != "nil" {
                self.questionNumberOfficial = Int((snapshot.value as? String)!)
                
                if self.questionNumberOfficial != nil {
                    self.questionTextView.text = self.questionArray[self.questionNumberOfficial!].question
                    if self.questionArray[self.questionNumberOfficial!].answerA.hasPrefix("!") {
                        self.aButton.setTitle(String(self.questionArray[self.questionNumberOfficial!].self.answerA.characters.dropFirst()), forState: .Normal)
                        
                    }
                    else {
                        self.aButton.setTitle(self.questionArray[self.questionNumberOfficial!].self.answerA, forState: .Normal)
                    }
                    
                    if self.questionArray[self.questionNumberOfficial!].self.answerB.hasPrefix("!") {
                        self.bButton.setTitle(String(self.questionArray[self.questionNumberOfficial!].self.answerB.characters.dropFirst()), forState: .Normal)
                    }
                    else {
                        self.bButton.setTitle(self.questionArray[self.questionNumberOfficial!].self.answerB, forState: .Normal)
                    }
                    
                    if self.questionArray[self.questionNumberOfficial!].self.answerC.hasPrefix("!") {
                        self.cButton.setTitle(String(self.questionArray[self.questionNumberOfficial!].self.answerC.characters.dropFirst()), forState: .Normal)
                    }
                    else {
                        self.cButton.setTitle(self.questionArray[self.questionNumberOfficial!].self.answerC, forState: .Normal)
                    }
                    
                    if self.questionArray[self.questionNumberOfficial!].self.answerD.hasPrefix("!") {
                        self.dButton.setTitle(String(self.questionArray[self.questionNumberOfficial!].self.answerD.characters.dropFirst()), forState: .Normal)
                    }
                    else {
                        self.dButton.setTitle(self.questionArray[self.questionNumberOfficial!].self.answerD, forState: .Normal)
                    }
                }
            }
            
        })


        
        
        
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).childByAppendingPath("questionRandNumber").observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.value as? String != nil {
                self.questionNumberOfficial = Int((snapshot.value as? String)!)
                print("question found")
            }
        })


        
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).observeEventType(.Value, withBlock: { snapshot in
            if self.isHost == true {
                self.myScoreLabel.text = snapshot.childSnapshotForPath("myScore").value as? String
                self.opponentScoreLabel.text = snapshot.childSnapshotForPath("opponentScore").value as? String
            }
            else {
                self.myScoreLabel.text = snapshot.childSnapshotForPath("opponentScore").value as? String
                self.opponentScoreLabel.text = snapshot.childSnapshotForPath("myScore").value as? String
            }
            
        })
        

        
        
        
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).childByAppendingPath("questionRandNumber").observeEventType(.Value, withBlock: { snapshot in
            if snapshot.value as? String != "" && self.gameCreated == false {
                print("fag4")
                self.questionNumberOfficial = Int((snapshot.value as? String)!)
                self.playGame()
                self.gameCreated = true
              
            }
        })


        
        if isHost == true {
            print("fag")
            
            /*rand = Int(arc4random_uniform(UInt32(questionArray.count)))
            
            DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).childByAppendingPath("questionRandNumber").setValue(String(rand!))
            */
            DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).childByAppendingPath("opponent").observeEventType(.Value, withBlock: { snapshot in
                
                if snapshot.value as? String != "" && self.gameCreated == false {
                    print("faggot1")
                    self.playGame()
                    self.gameCreated = true
                }
            })
        }
        
        
        
        
        /*if DataService.ds.REF_BASE.authData.uid == "63f1400f-5d06-4fa5-9074-af4067b88a39" {
            
            //display my score
            DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("inGame").childByAppendingPath("myScore").observeEventType(.Value, withBlock: { snapshot in
                
                self.myScoreLabel.text = snapshot.value as? String
                
            })
            //display opponent score
            DataService.ds.REF_USERS.childByAppendingPath("7524bac2-2247-4f6d-8361-fab1dbd622e4").childByAppendingPath("inGame").childByAppendingPath("myScore").observeEventType(.Value, withBlock: { snapshot in
                self.opponentScoreLabel.text = snapshot.value as? String
                
            })
            
            DataService.ds.REF_USERS.childByAppendingPath("7524bac2-2247-4f6d-8361-fab1dbd622e4").childByAppendingPath("inQueue").observeEventType(.Value, withBlock: { snapshot in
                if snapshot.value as? Bool == true {
                    self.playGame()
                  
                }
                
            })
        }*/
        /*else {
            
            //display my score
            DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("inGame").childByAppendingPath("myScore").observeEventType(.Value, withBlock: { snapshot in
                self.myScoreLabel.text = snapshot.value as? String
               
                
            })
            //display opponent score
            DataService.ds.REF_USERS.childByAppendingPath("63f1400f-5d06-4fa5-9074-af4067b88a39").childByAppendingPath("inGame").childByAppendingPath("myScore").observeEventType(.Value, withBlock: { snapshot in
                self.opponentScoreLabel.text = snapshot.value as? String
               
            })
            
            DataService.ds.REF_USERS.childByAppendingPath("63f1400f-5d06-4fa5-9074-af4067b88a39").childByAppendingPath("inQueue").observeEventType(.Value, withBlock: { snapshot in
                if snapshot.value as? Bool == false {
                    self.playGame()
                   
                }
            })
        }*/



    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func displayQuestion() {
        rand = Int(arc4random_uniform(UInt32(questionArray.count)))
        
        if numberOfQuestions == 3 {
            DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).childByAppendingPath("questionRandNumber").removeAllObservers()
            print("game is over")
            endGame()
            timer?.invalidate()
        }
        else {
            if isHost == true {
                
                DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).childByAppendingPath("questionRandNumber").setValue(String(rand!))
                print("should have changed the question")
                
                
            }
            
            DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).childByAppendingPath("questionRandNumber").observeSingleEventOfType(.Value, withBlock: { snapshot in
                if snapshot.value as? String != "" {
                    self.questionNumberOfficial = Int((snapshot.value as? String)!)
                }
                
            })
            
            
            DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).childByAppendingPath("questionRandNumber").observeEventType(.Value, withBlock: { snapshot in
                if snapshot.value as? String != "" {
                    self.questionNumberOfficial = Int((snapshot.value as? String)!)
                }
                
            })
            
            
            
            enableButtons()
            numberOfQuestions += 1
            print(numberOfQuestions)
            print(questionNumberOfficial)
        }
        
       
        
      
        
        
        

       
        
        
    }
    
    func playGame() {
       
        myScore = 0
            
            
        displayQuestion()
        searchingForOpponentLabel.hidden = true
        aButton.hidden = false
        bButton.hidden = false
        cButton.hidden = false
        dButton.hidden = false
        questionTextView.hidden = false
        myScoreLabel.hidden = false
        opponentScoreLabel.hidden = false
        meLabel.hidden = false
        opponentLabel.hidden = false
            
        timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "displayQuestion", userInfo: nil, repeats: true)
        
    }
    func parseQuestionsCSV() {
        let path = NSBundle.mainBundle().pathForResource("QuestionList", ofType: "csv")
        
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            
            for row in rows {
                let question = row["question"]!
                let answerA = row["answerA"]!
                let answerB = row["answerB"]!
                let answerC = row["answerC"]!
                let answerD = row["answerD"]!
                let questionFinished = Question(question: question, answerA: answerA, answerB: answerB, answerC: answerC, answerD: answerD)
                questionArray.append(questionFinished)
            }
        }
        catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func onAButtonPressed(sender: AnyObject) {
        disableButtons()
        if questionArray[questionNumberOfficial!].answerA.hasPrefix("!") {
            myScore += 1
        }
        
        addScore()
        
    }
    
    @IBAction func onBButtonPressed(sender: AnyObject) {
        disableButtons()
        if questionArray[questionNumberOfficial!].answerB.hasPrefix("!") {
            myScore += 1
        }
        
        addScore()
        
    }
    
    @IBAction func onCButtonPressed(sender: AnyObject) {
        disableButtons()
        if questionArray[questionNumberOfficial!].answerC.hasPrefix("!") {
            myScore += 1
        }
        
        addScore()
        
    }
    
    @IBAction func onDButtonPressed(sender: AnyObject) {
        disableButtons()
        if questionArray[questionNumberOfficial!].answerD.hasPrefix("!") {
            myScore += 1
        }
        
        addScore()
       
    }
    
    func addScore() {
        
        if isHost == true {
            DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).childByAppendingPath("myScore").setValue(String(myScore))
        }
        else {
            DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).childByAppendingPath("opponentScore").setValue(String(myScore))
        }
        
    }
    
    func disableButtons() {
        aButton.enabled = false
        bButton.enabled = false
        cButton.enabled = false
        dButton.enabled = false
    }
    
    func enableButtons() {
        aButton.enabled = true
        bButton.enabled = true
        cButton.enabled = true
        dButton.enabled = true
    }
    
    func endGame() {
        
        aButton.hidden = true
        bButton.hidden = true
        cButton.hidden = true
        dButton.hidden = true
        questionTextView.hidden = true
        myScoreLabel.hidden = true
        opponentScoreLabel.hidden = true
        meLabel.hidden = true
        opponentLabel.hidden = true
        outcomeLabel.hidden = false
        
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).childByAppendingPath("questionRandNumber").removeAllObservers()
        
        
        DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(hostName).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if self.isHost == true {
                if Int((snapshot.childSnapshotForPath("myScore").value as? String)!) > Int((snapshot.childSnapshotForPath("opponentScore").value as? String)!) {
                    self.outcomeLabel.text = "You Win"
                    
                    self.wins = self.wins! + 1
                    
                    DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("wins").setValue(self.wins!)
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).childByAppendingPath("questionRandNumber").removeAllObservers()
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).removeAllObservers()
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).removeValue()
                    
                }
                if Int((snapshot.childSnapshotForPath("myScore").value as? String)!) < Int((snapshot.childSnapshotForPath("opponentScore").value as? String)!) {
                    self.outcomeLabel.text = "You Lose"
                    
                    self.losses = self.losses! + 1
                    
                    DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("losses").setValue(self.losses!)
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).childByAppendingPath("questionRandNumber").removeAllObservers()
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).removeAllObservers()
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).removeValue()
                }
                if Int((snapshot.childSnapshotForPath("myScore").value as? String)!) == Int((snapshot.childSnapshotForPath("opponentScore").value as? String)!) {
                    self.outcomeLabel.text = "It's A Tie!"
                    
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).childByAppendingPath("questionRandNumber").removeAllObservers()
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).removeAllObservers()
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).removeValue()
                }
            }
            else {
                if Int((snapshot.childSnapshotForPath("myScore").value as? String)!) < Int((snapshot.childSnapshotForPath("opponentScore").value as? String)!) {
                    self.outcomeLabel.text = "You Win"
                    
                    self.wins = self.wins! + 1
                    
                    DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("wins").setValue(self.wins!)
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).childByAppendingPath("questionRandNumber").removeAllObservers()
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).removeAllObservers()
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).removeValue()
                }
                if Int((snapshot.childSnapshotForPath("myScore").value as? String)!) > Int((snapshot.childSnapshotForPath("opponentScore").value as? String)!) {
                    self.outcomeLabel.text = "You Lose"
                    
                    self.losses = self.losses! + 1
                    
                    DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("losses").setValue(self.losses!)
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).childByAppendingPath("questionRandNumber").removeAllObservers()
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).removeAllObservers()
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).removeValue()
                }
                if Int((snapshot.childSnapshotForPath("myScore").value as? String)!) == Int((snapshot.childSnapshotForPath("opponentScore").value as? String)!) {
                    self.outcomeLabel.text = "It's A Tie!"
                    
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).childByAppendingPath("questionRandNumber").removeAllObservers()
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).removeAllObservers()
                    DataService.ds.REF_BASE.childByAppendingPath("currentGames").childByAppendingPath(self.hostName).removeValue()
                }
            }
        })
        
        
        
       // DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("inGame").childByAppendingPath("myScore").observeEventType(.Value, withBlock: { snapshot in
           // myScore = snapshot.value as! Int
            
        //})
        //DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("inGame").childByAppendingPath("opponentScore").observeEventType(.Value, withBlock: { snapshot in
          //  opponentScore = snapshot.value as! Int
            
       // })
        
        //if myScore > opponentScore {
           // DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("wins").setValue("1")
           // outcomeLabel.text = "You Won!"
        //}
        /*else if myScore < opponentScore {
            DataService.ds.REF_USERS.childByAppendingPath(DataService.ds.REF_BASE.authData.uid).childByAppendingPath("losses").setValue("1")
            outcomeLabel.text = "Loser!"
        }
        
        else {
            outcomeLabel.text = "Tie!"
        }
        
        numberOfQuestions = 0*/
    }
    
    @IBAction func onBackButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    
}
