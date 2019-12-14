//
//  CardGame.swift
//  CMP430-Final
//
//  Created by Sabri Sönmez on 12/11/19.
//  Copyright © 2019 Sabri Sönmez. All rights reserved.
//

import Foundation
struct CardGame
{
    var deck = PlayingCardDeck.init()
    var cards = [PlayingCard]()
    var cardsInGameUser = [PlayingCard]()
    var cardsInGameCPU = [PlayingCard]()
    var userScore = 0
    var cpuScore = 0
    var userBalance = 100
    var userBet = 0
    var gameLbl = ""
    
    init() {
        newGame()
    }
    
    mutating func newGame(){
        userScore = 0
        cpuScore = 0
        userBalance = 100
        userBet = 0
        cards = deck.cards
        cards.shuffle()
    }
    
    private mutating func addCardUser()
    {
        let randomInt = Int.random(in: 0..<cards.count)
        let selectedCard = cards.remove(at: randomInt)
        
        cardsInGameUser.append(selectedCard)
        
    }
    
    private mutating func addCardCPU()
    {
        let randomInt = Int.random(in: 0..<cards.count)
        let selectedCard = cards.remove(at: randomInt)
        
        cardsInGameCPU.append(selectedCard)
    }
    
    
    mutating func addCardsUser(numberOfCardsToAdd numberOfCards: Int)
    {
        for _ in 0..<numberOfCards
        {
            addCardUser()
        }
    }
    
    mutating func addCardsCPU(numberOfCardsToAdd numberOfCards: Int)
    {
        for _ in 0..<numberOfCards
        {
            addCardCPU()
        }
    }
    
    mutating func calcUserScore() {
        for index in cardsInGameUser.indices{
            
            userScore += cardsInGameUser[index].rank.order
            
            if cardsInGameUser[index].suit == "♠️"{
                self.userScore += 4
            }
            if cardsInGameUser[index].suit == "❤️"{
                self.userScore += 3
            }
            if cardsInGameUser[index].suit ==  "♦️"{
                self.userScore += 2
            }
            if cardsInGameUser[index].suit == "♣️"{
                self.userScore += 1
            }
        }
    }
    
    mutating func checkScore() {
        if cardsInGameCPU.count >= 3, cardsInGameUser.count >= 3
        {
            for index in cardsInGameCPU.indices
            {
                 cpuScore += cardsInGameCPU[index].rank.order
                if cardsInGameCPU[index].suit == "♠️"{
                    self.cpuScore += 4
                }
                if cardsInGameCPU[index].suit == "❤️"{
                    self.cpuScore += 3
                }
                if cardsInGameCPU[index].suit ==  "♦️"{
                    self.cpuScore += 2
                }
                if cardsInGameCPU[index].suit == "♣️"{
                     self.cpuScore += 1
                }
            }
            
            for index in cardsInGameUser.indices{
                
                userScore += cardsInGameUser[index].rank.order
                
                if cardsInGameUser[index].suit == "♠️"{
                    self.userScore += 4
                }
                if cardsInGameUser[index].suit == "❤️"{
                    self.userScore += 3
                }
                if cardsInGameUser[index].suit ==  "♦️"{
                    self.userScore += 2
                }
                if cardsInGameUser[index].suit == "♣️"{
                    self.userScore += 1
                }
            }
            
            if userScore > cpuScore
            {
                if userScore >= cpuScore * 2
                {
                    userBalance += userBet*2
                    gameLbl = "Jackpot! You're a Winner + \(userBet * 2)..."
                }
                else
                {
                    userBalance += userBet
                }
                gameLbl = "Congrats! You're a Winner + \(userBet)..."
            }
            
            if cpuScore > userScore
            {
                userBalance -= userBet
                 gameLbl = "Tough Luck! You Lost - \(userBet)..."
            }
            //userBet = 0
        }
    }
    
    
    
    
}
