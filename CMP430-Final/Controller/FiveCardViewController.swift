//
//  FiveCardViewController.swift
//  CMP430-Final
//
//  Created by Sabri Sönmez on 12/14/19.
//  Copyright © 2019 Sabri Sönmez. All rights reserved.
//

import UIKit

class FiveCardViewController: UIViewController {

    @IBOutlet weak var userCardContainerView: CardContainerView!
    @IBOutlet weak var cpuCardContainerView: CardContainerView!
    @IBOutlet weak var cpuScoreLbl: UILabel!
    
    @IBOutlet weak var betBtn: UIButton!
    @IBOutlet weak var dealBtn: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var gameLbl: UILabel!
    @IBOutlet weak var userBetLbl: UILabel!
    @IBOutlet weak var userBalanceLbl: UILabel!
    @IBOutlet weak var userScoreLbl: UILabel!
    @IBOutlet weak var deckImage: UIImageView!
    var numberOfPresses = 0
    var numberOfswipes = 0
    var game = CardGame()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateViewFromModel()
    }
    
    
    @IBAction func dealBtnPressed(_ sender: Any)
    {
        if game.userBet == 0, numberOfPresses < 1
        {
            game.cardsInGameUser.removeAll()
            game.cardsInGameCPU.removeAll()
            
            game.addCardsUser(numberOfCardsToAdd: 5)
            game.addCardsCPU(numberOfCardsToAdd: 5)
            
            print("User cards: \(game.cardsInGameUser)")
            print("CPU cards: \(game.cardsInGameCPU)")
            
            for view in self.userCardContainerView.subviews {
                view.removeFromSuperview()
            }
            for index in game.cardsInGameUser.indices{
                
                let subView = PlayingCardView()
                subView.rank = game.cardsInGameUser[index].rank.order
                subView.suit = game.cardsInGameUser[index].suit
                subView.isFaceUp = game.cardsInGameUser[index].isFaceUp
                
                userCardContainerView.addSubview(subView)
                userCardContainerView.isAnimated = true
                subView.frame = self.deckImage.frame
                betBtn.isEnabled.toggle()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    UIView.transition(with: subView, duration: 1, options: .transitionFlipFromLeft, animations: {
                        
                        //view.transform = CGAffineTransform(scaleX: 3, y: 3)
                        
                        subView.isFaceUp.toggle()
                        
                    }) { finished in
                        
                        // completion
                    }
                })
            }
            
            for view in self.userCardContainerView.subviews {
                let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
                swipeRight.direction = UISwipeGestureRecognizer.Direction.right
                view.addGestureRecognizer(swipeRight)
                //
                //                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(getIndex(_:)))
                //                view.addGestureRecognizer(gestureRecognizer)
                //
            }
            self.game.calcUserScore()
            self.updateLabels()
            numberOfPresses += 1
        }
        else
        {
            if game.userBet > 0
            {
                
                for view in self.cpuCardContainerView.subviews {
                    view.removeFromSuperview()
                }
                for index in game.cardsInGameCPU.indices{
                    
                    let subView = PlayingCardView()
                    subView.rank = game.cardsInGameCPU[index].rank.order
                    subView.suit = game.cardsInGameCPU[index].suit
                    subView.isFaceUp = game.cardsInGameCPU[index].isFaceUp
                    
                    cpuCardContainerView.addSubview(subView)
                    cpuCardContainerView.isAnimated = true
                    
                    subView.frame = self.deckImage.frame
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        UIView.transition(with: subView, duration: 1, options: .transitionFlipFromLeft, animations: {
                            
                            //view.transform = CGAffineTransform(scaleX: 3, y: 3)
                            
                            subView.isFaceUp.toggle()
                            
                        }) { finished in
                            
                            // completion
                            
                        }
                        
                    })
                }
                
                game.userScore = 0
                game.checkScore()
                updateLabels()
                gameLbl.isHidden = false
                numberOfPresses = 0
                dealBtn.isEnabled.toggle()
                betBtn.isEnabled.toggle()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute:
                    {
                        self.gameLbl.isHidden = true
                        self.numberOfswipes = 0
                        self.game.userScore = 0
                        self.game.userBet = 0
                        self.game.cpuScore = 0
                        self.updateViewFromModel()
                        self.dealBtn.isEnabled.toggle()
                        self.betBtn.isEnabled.toggle()
                })
            }else{
                let alert = UIAlertController(title: "Insufficient Bet", message: "You need to bet at least $1 to play.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            
        }
        
        
        
        
    }
    
    @IBAction func resetBtnPressed(_ sender: Any)
    {
        numberOfswipes = 0
        numberOfPresses = 0
        game.newGame()
        updateLabels()
        updateViewFromModel()
    }
    @IBAction func betBtnPressed(_ sender: Any) {
        game.userBet += 1
        updateLabels()
        
    }
    func updateLabels()
    {
        gameLbl.text = game.gameLbl
        cpuScoreLbl.text = "CPU Score: \(game.cpuScore)"
        userScoreLbl.text = "Score: \(game.userScore)"
        userBalanceLbl.text = "Balance: $\(game.userBalance)"
        userBetLbl.text = "Bet: $\(game.userBet)"
    }
    
    func updateViewFromModel()
    {
        betBtn.isEnabled.toggle()
        updateLabels()
        gameLbl.isHidden = true
        
        for view in self.userCardContainerView.subviews {
            view.removeFromSuperview()
        }
        for index in 0...4{
            
            let subView = StartView()
            subView.rank = game.cards[index].rank.order
            subView.suit = game.cards[index].suit
            subView.isFaceUp = game.cards[index].isFaceUp
            
            userCardContainerView.addSubview(subView)
            userCardContainerView.isAnimated = false
            
        }
        
        for view in self.cpuCardContainerView.subviews {
            view.removeFromSuperview()
        }
        for index in 0...4{
            
            let subView = StartView()
            subView.rank = game.cards[index].rank.order
            subView.suit = game.cards[index].suit
            subView.isFaceUp = game.cards[index].isFaceUp
            
            cpuCardContainerView.addSubview(subView)
            cpuCardContainerView.isAnimated = false
            
        }
        
    }
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                //print("Swiped right")
                if numberOfswipes<1
                {
                    let chosenCardView = gesture.view as! PlayingCardView
                    let cardNumber = userCardContainerView.subviews.firstIndex(of: gesture.view!)
                    UIView.transition(with: chosenCardView, duration: 1, options: .transitionFlipFromLeft, animations: {
                        
                        
                        
                        chosenCardView.center = CGPoint(x: self.mainView.frame.size.width, y: self.mainView.frame.origin.y)
                        chosenCardView.isFaceUp.toggle()
                        
                        
                    }) { finished in
                        
                        // completion
                        chosenCardView.removeFromSuperview()
                        self.numberOfswipes += 1
                    }
                    
                    self.game.cardsInGameUser.remove(at: cardNumber!)
                    self.game.addCardsUser(numberOfCardsToAdd: 1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.game.userScore = 0
                        self.updateUserCard()
                        self.updateLabels()
                        
                    })
                    print("usernew: \(game.cardsInGameUser)")
                }else{
                    let alert = UIAlertController(title: "Already Used", message: "You only have the option of trading up to 1 card to improve your score", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                }
                
                
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func updateUserCard() {
        
        let subView = PlayingCardView()
        subView.rank = game.cardsInGameUser[game.cardsInGameUser.endIndex - 1].rank.order
        subView.suit = game.cardsInGameUser[game.cardsInGameUser.endIndex - 1].suit
        subView.isFaceUp = game.cardsInGameUser[game.cardsInGameUser.endIndex - 1].isFaceUp
        
        userCardContainerView.addSubview(subView)
        userCardContainerView.isAnimated = true
        subView.frame = self.deckImage.frame
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            UIView.transition(with: subView, duration: 1, options: .transitionFlipFromLeft, animations: {
                
                subView.isFaceUp.toggle()
                
            }) { finished in
                
                // completion
            }
        })
        
        
        for view in self.userCardContainerView.subviews
        {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            view.addGestureRecognizer(swipeRight)
        }
        self.game.calcUserScore()
        self.updateLabels()
        numberOfPresses += 1
    }
}
