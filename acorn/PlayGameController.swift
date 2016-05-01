//
//  PlayGameController.swift
//  acorn
//
//  Created by Oli Eydt on 2016-04-29.
//  Copyright © 2016 Swaggerz Light. All rights reserved.
//

import UIKit

class PlayGameController: UIViewController {

    //UI elements
    @IBOutlet var backButton: UIButton!
    var mountains1ImageView: UIImageView!
    var backTrees1ImageView: UIImageView!
    var frontTrees1ImageView: UIImageView!
    var mountains2ImageView: UIImageView!
    var backTrees2ImageView: UIImageView!
    var frontTrees2ImageView: UIImageView!
    
    @IBOutlet var instructionsLabel: UILabel!
    var scoreLabel: UILabel!
    var chipImageView: UIImageView!
    var leftBranchImageView: UIImageView!
    var rightBranchImageView: UIImageView!
    //Screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    //Timer to make chip move
    var timer = NSTimer()
    
    //variables for movement of elements
    var speedMove: Double = 0
    var firstTouch: Bool = true
    var bouncePressed = false
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(firstTouch){
            //reset speed constants
            fallSpeed = 8
            fallAlone = 1
            backButton.hidden = true
            setChipInitialPosition()
            firstTouch = false
            instructionsLabel.hidden = true
            scoreLabel.text = "0"
            scoreLabel.hidden = false
            //start the game
            timer = NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: #selector(PlayGameController.startGame), userInfo: nil, repeats: true)
        } else{
            bouncePressed = true
        }
        
        
        super.touchesBegan(touches, withEvent:event)
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("HomeScreenController", sender: nil)
    }
    func setChipInitialPosition(){
        chipImageView.hidden = false
        chipImageView.frame = CGRect(x: Int(screenSize.width/2 - 50), y: 0, width: 35, height: 35)

    }
    
    func startGame(){
        moveChip()
        moveBranch()
        moveBackground()
    }
    
    var fallSpeed: Double = 8
    var fallAlone: Double = 1
    var hasJumped = false
    func chipJump(){
        if(bouncePressed){
            bouncePressed=false
        
            hasJumped = true
            fallSpeed = -17
            chipImageView.center.y += CGFloat(fallSpeed)
            fallSpeed+=1
           
        } else if(hasJumped){
           
            chipImageView.center.y += CGFloat(fallSpeed)
            fallSpeed+=1
            if(fallSpeed>=15){
                fallSpeed = 15
            }
        }
    }
    
    var bringToTopBranch = true
    func moveChip(){
        if(chipImageView.frame.intersects(leftBranchImageView.frame)){

            
            hasJumped = false
            chipJump()
        } else if(chipImageView.frame.intersects(rightBranchImageView.frame)){
            
            hasJumped = false
            chipJump()
        } else {
            chipJump()
            if(!hasJumped){
                fallAlone+=1
                if(fallAlone>=8){
                    fallAlone = 8
                }
                chipImageView.center.y += CGFloat(fallAlone)
            }
            
        }
        
        
        //stop game if chip is out of bounds
        if(chipImageView.frame.minY>=screenSize.height){
            timer.invalidate()
            backButton.hidden = false
           instructionsLabel.hidden = false
            firstTouch = true
        }
        
    }
    
    func moveBackground(){
        
        mountains1ImageView.center.x = mountains1ImageView.center.x - 1
        mountains2ImageView.center.x = mountains2ImageView.center.x - 1
        if(mountains1ImageView.frame.maxX<=0){
            mountains1ImageView.center.x = screenSize.width+mountains1ImageView.frame.width/2.0
        }
        if(mountains2ImageView.frame.maxX<=0){
            mountains2ImageView.center.x = screenSize.width+mountains2ImageView.frame.width/2.0
        }
        
        backTrees1ImageView.center.x = backTrees1ImageView.center.x - 2
        backTrees2ImageView.center.x = backTrees2ImageView.center.x - 2
        if(backTrees1ImageView.frame.maxX<=0){
            backTrees1ImageView.center.x = screenSize.width+backTrees1ImageView.frame.width/2.0
        }
        if(backTrees2ImageView.frame.maxX<=0){
            backTrees2ImageView.center.x = screenSize.width+backTrees2ImageView.frame.width/2.0
        }
        
        frontTrees1ImageView.center.x = frontTrees1ImageView.center.x - 3
        frontTrees2ImageView.center.x = frontTrees2ImageView.center.x - 3
        if(frontTrees1ImageView.frame.maxX<=0){
            frontTrees1ImageView.center.x = screenSize.width+frontTrees1ImageView.frame.width/2.0
        }
        if(frontTrees2ImageView.frame.maxX<=0){
            frontTrees2ImageView.center.x = screenSize.width+frontTrees2ImageView.frame.width/2.0
        }
        
    }
    
    func moveBranch() {
        
        if(leftBranchImageView.frame.maxX<=0){
            leftBranchImageView.center.x = screenSize.width+leftBranchImageView.frame.width/2.0
            var upOrDown = 0 - Int(arc4random_uniform(2))
            if(upOrDown == 0){
                upOrDown = 1
            }
            
            leftBranchImageView.center.y = CGFloat(Int(arc4random_uniform(UInt32(screenSize.height/3))) * upOrDown) + screenSize.height/2
            //adjust score
            scoreLabel.text = String(Int(scoreLabel.text!)!+1)
        }
        if(rightBranchImageView.frame.maxX<=0){
            rightBranchImageView.center.x = screenSize.width+rightBranchImageView.frame.width/2.0
            var upOrDown = 0 - Int(arc4random_uniform(2))
            if(upOrDown == 0){
                upOrDown = 1
            }
            rightBranchImageView.center.y = CGFloat(Int(arc4random_uniform(UInt32(screenSize.height/3))) * upOrDown) + screenSize.height/2
            scoreLabel.text = String(Int(scoreLabel.text!)!+1)
        }
        
        
        //move branches
        leftBranchImageView.center.x = CGFloat(Double(leftBranchImageView.center.x) - 4.5 + speedMove)
        rightBranchImageView.center.x = CGFloat(Double(rightBranchImageView.center.x) - 4.5 + speedMove)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        instructionsLabel.hidden = false
        //add background
        let mountains1Image = UIImage(named: "montagnes.png")
        mountains1ImageView = UIImageView(image: mountains1Image!)
        mountains1ImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        self.view.addSubview(mountains1ImageView)
        let mountains2Image = UIImage(named: "montagnes.png")
        mountains2ImageView = UIImageView(image: mountains2Image!)
        mountains2ImageView.frame = CGRect(x: screenSize.width, y: 0, width: screenSize.width, height: screenSize.height)
        self.view.addSubview(mountains2ImageView)
        let backTrees1Image = UIImage(named: "arbres_bg.png")
        backTrees1ImageView = UIImageView(image: backTrees1Image!)
        backTrees1ImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        self.view.addSubview(backTrees1ImageView)
        let backTrees2Image = UIImage(named: "arbres_bg.png")
        backTrees2ImageView = UIImageView(image: backTrees2Image!)
        backTrees2ImageView.frame = CGRect(x: screenSize.width, y: 0, width: screenSize.width, height: screenSize.height)
        self.view.addSubview(backTrees2ImageView)
        let frontTrees1Image = UIImage(named: "arbres_fg.png")
        frontTrees1ImageView = UIImageView(image: frontTrees1Image!)
        frontTrees1ImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        self.view.addSubview(frontTrees1ImageView)
        let frontTrees2Image = UIImage(named: "arbres_fg.png")
        frontTrees2ImageView = UIImageView(image: frontTrees2Image!)
        frontTrees2ImageView.frame = CGRect(x: screenSize.width, y: 0, width: screenSize.width, height: screenSize.height)
        self.view.addSubview(frontTrees2ImageView)

        
        
        //adding chip
        let chipImage = UIImage(named: "doge.png")
        chipImageView = UIImageView(image: chipImage!)
        let randChipHeight = Int(arc4random_uniform(150))
        chipImageView.frame = CGRect(x: Int(screenSize.width/2 - 50), y: Int(screenSize.height/2) + randChipHeight, width: 35, height: 35)
        chipImageView.hidden = true
        self.view.addSubview(chipImageView)
        //adding left branch
        let leftBranchImage = UIImage(named: "pongtrypaddle.png")
        leftBranchImageView = UIImageView(image: leftBranchImage!)
        leftBranchImageView.frame = CGRect(x: 0, y: Int(chipImageView.center.y) + 40, width: 110, height: 30)
        self.view.addSubview(leftBranchImageView)
        //adding right branch
        let rightBranchImage = UIImage(named: "pongtrypaddle.png")
         let randRightBranchHeight = Int(arc4random_uniform(150))
        rightBranchImageView = UIImageView(image: rightBranchImage!)
        rightBranchImageView.frame = CGRect(x: Int(screenSize.width) - Int(leftBranchImageView.bounds.width), y: Int(screenSize.height)/2 + randRightBranchHeight, width: 110, height: 30)
        self.view.addSubview(rightBranchImageView)
        
        
        //show score
        scoreLabel = UILabel()
        scoreLabel.hidden = true
        scoreLabel.font = UIFont(name: "Cochin", size: 59)
        scoreLabel.text = "0"
        scoreLabel.frame = CGRectMake(self.view.frame.width/2, 20, 60, 60)
        self.view.addSubview(scoreLabel)
        
        self.view.bringSubviewToFront(instructionsLabel)
        self.view.bringSubviewToFront(chipImageView)
        self.view.bringSubviewToFront(backButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
