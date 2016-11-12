//
//  StartScreenViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {
    
    var gameTitle : UILabel = UILabel()
    var startButton : UIButton = UIButton(type: UIButtonType.roundedRect)
    var hangmanImages : UIImageView = UIImageView(image: #imageLiteral(resourceName: "hangman7.gif"))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        gameTitle.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        hangmanImages.translatesAutoresizingMaskIntoConstraints = false
        // Game Title
        gameTitle.text = "Hangman"
        gameTitle.font = UIFont.boldSystemFont(ofSize: 36.0)
        view.addSubview(gameTitle)
        // "New Game" Button
        startButton.setTitle("New Game", for: .normal)
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.backgroundColor = UIColor(red:0.33, green:0.75, blue:0.88, alpha:1.0)
        startButton.layer.cornerRadius = 6
        startButton.clipsToBounds = true
        startButton.contentEdgeInsets  = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10.0)
        view.addSubview(startButton)
        // A Hangman Image Animation
        hangmanImages.animationImages = [#imageLiteral(resourceName: "hangman1.gif"), #imageLiteral(resourceName: "hangman2.gif"), #imageLiteral(resourceName: "hangman3.gif"), #imageLiteral(resourceName: "hangman4.gif"), #imageLiteral(resourceName: "hangman5.gif"), #imageLiteral(resourceName: "hangman6.gif"), #imageLiteral(resourceName: "hangman7.gif")]
        hangmanImages.animationDuration = 1.0
        hangmanImages.animationRepeatCount = 1
        hangmanImages.startAnimating()
        view.addSubview(hangmanImages)
        view.setNeedsUpdateConstraints()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLayoutConstraint(item: gameTitle, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: gameTitle, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.33, constant: 0.0).isActive = true
        NSLayoutConstraint(item: startButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: startButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.6, constant: 0.0).isActive = true
        NSLayoutConstraint(item: hangmanImages, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: hangmanImages, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.4, constant: 0.0).isActive = true
    }
    
    func startButtonTapped(sender: UIButton!) {
        let gameViewController = GameViewController()
        self.present(gameViewController, animated: true, completion: nil)
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
