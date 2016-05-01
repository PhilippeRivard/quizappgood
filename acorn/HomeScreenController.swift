//
//  ViewController.swift
//  acorn
//
//  Created by Oli Eydt on 2016-04-29.
//  Copyright © 2016 Swaggerz Light. All rights reserved.
//

import UIKit

class HomeScreenController: UIViewController {

    
    
    //UI elements
    @IBOutlet var startButton: UIButton!
    var mountains1ImageView: UIImageView!
    var backTrees1ImageView: UIImageView!
    var frontTrees1ImageView: UIImageView!
    var mountains2ImageView: UIImageView!
    var backTrees2ImageView: UIImageView!
    var frontTrees2ImageView: UIImageView!
    
    //Screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    @IBAction func startButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("PlayGameController", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        //bring start button to front
        self.view.bringSubviewToFront(startButton)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

