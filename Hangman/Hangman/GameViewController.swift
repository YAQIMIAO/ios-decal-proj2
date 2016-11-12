//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit
import Foundation

extension UILabel {
    func addCharactersSpacing(spacing:CGFloat, text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, text.characters.count))
        self.attributedText = attributedString
    }
}

class GameViewController: UIViewController, UITextFieldDelegate {
    
    var puzzleLabel : UILabel = UILabel()
    var wrongGuesses : UILabel = UILabel()
    var correctGuesses : Set<Character> = []
    var hangmanImage : UIImageView?
    var letterInput : UITextField?
    var submitButton : UIButton?
    var phrase : String? = nil
    var hangmanImages = [#imageLiteral(resourceName: "hangman1.gif"), #imageLiteral(resourceName: "hangman2.gif"), #imageLiteral(resourceName: "hangman3.gif"), #imageLiteral(resourceName: "hangman4.gif"), #imageLiteral(resourceName: "hangman5.gif"), #imageLiteral(resourceName: "hangman6.gif"), #imageLiteral(resourceName: "hangman7.gif")]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        print(phrase!)
        
        view.backgroundColor = UIColor.white
        puzzleLabel.translatesAutoresizingMaskIntoConstraints = false
        wrongGuesses.translatesAutoresizingMaskIntoConstraints = false
        // puzzle string all "_"
        var str : String = ""
        for c in phrase!.characters {
            if c == " " {
                str += " "
            } else {
                str += "_"
            }
        }
        puzzleLabel.addCharactersSpacing(spacing: 5.0, text:str)
        puzzleLabel.numberOfLines = 0
        view.addSubview(puzzleLabel)
        // wrong guesses
        wrongGuesses.textColor = UIColor(red:0.95, green:0.61, blue:0.60, alpha:1.0)
        view.addSubview(wrongGuesses)
        // image
        hangmanImage = UIImageView(image: #imageLiteral(resourceName: "hangman1.gif"))
        hangmanImage!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hangmanImage!)
        // input
        letterInput = UITextField()
        letterInput!.translatesAutoresizingMaskIntoConstraints = false
        letterInput!.delegate = self
        letterInput!.placeholder = "Guess a letter"
        view.addSubview(letterInput!)
        // button
        submitButton = UIButton()
        submitButton!.translatesAutoresizingMaskIntoConstraints = false
        submitButton?.setTitle("Try", for: .normal)
        submitButton!.backgroundColor = UIColor(red:0.33, green:0.75, blue:0.88, alpha:1.0)
        submitButton!.setTitleColor(UIColor.white, for: .normal)
        submitButton?.addTarget(self, action: #selector(GameViewController.guess), for: .touchUpInside)
        view.addSubview(submitButton!)
        view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 1
    }
    
    func guess(sender: UIButton!) {
        guard let letter = letterInput?.text else { return }
        guard letter.characters.count == 1 else { return }
        if let wrongGuessText = wrongGuesses.attributedText {
            if wrongGuessText.string.contains(letter) { return }
        }
        // do something
        let ch = letter.uppercased().characters.first! as Character
        if phrase!.localizedCaseInsensitiveContains(String(ch)) {
            correctGuesses.insert(ch)
        } else {
            if let wrongGuessText = wrongGuesses.attributedText {
                wrongGuesses.addCharactersSpacing(spacing: 5.0, text: wrongGuessText.string + String(ch))
            } else {
                wrongGuesses.addCharactersSpacing(spacing: 5.0, text: String(ch))
            }
        }
        updateViewAfterGuessing()
        // cleanup
        letterInput!.text = ""
    }
    
    func updateViewAfterGuessing() {
        // updates word label and hangman image
        var str: String = ""
        for c in phrase!.characters {
            if correctGuesses.contains(c) {
                str += String(c)
            } else if c == " " {
                str += " "
            } else {
                str += "_"
            }
        }
        print(str)
        puzzleLabel.addCharactersSpacing(spacing: 5.0, text: str)
        if let wrongGuessText = wrongGuesses.attributedText {
            hangmanImage!.image = hangmanImages[min(wrongGuessText.string.characters.count, 6)]
        }
        // decide whether game state changed (win or lose)
        if puzzleLabel.attributedText!.string.contains("_") {
            // lose ?
            if let wrongGuessText = wrongGuesses.attributedText {
                if wrongGuessText.string.characters.count >= 7 {
                    endGame(withWin: false)
                }
            }
        } else {
            // win !
            endGame(withWin: true)
        }
    }
    
    func endGame(withWin state: Bool) {
        var str: String
        if state {
            str = "You win"
        } else {
            str = "You lose"
        }
        let alert = UIAlertController(title: str, message: "Start a new game?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.alertActionHandler))
        alert.addAction(UIAlertAction(title: "Return", style: UIAlertActionStyle.default, handler: self.alertActionHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertActionHandler(alert: UIAlertAction) {
        var nextViewController: UIViewController
        if alert.title == "OK" {
            nextViewController = GameViewController()
        } else {
            nextViewController = StartScreenViewController()
        }
        self.present(nextViewController, animated: false, completion: nil)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLayoutConstraint(item: puzzleLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: puzzleLabel, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.3, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: wrongGuesses, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: wrongGuesses, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.4, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: hangmanImage!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: hangmanImage!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.05, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: letterInput!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0.0).isActive = true
        NSLayoutConstraint(item: letterInput!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 0.2, constant: 0.0).isActive = true
        NSLayoutConstraint(item: letterInput!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.5, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: submitButton!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.5, constant: 0.0).isActive = true
        submitButton!.leftAnchor.constraint(equalTo: letterInput!.rightAnchor, constant: 0.0).isActive = true
        NSLayoutConstraint(item: submitButton!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 0.8, constant: 0.0).isActive = true
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
