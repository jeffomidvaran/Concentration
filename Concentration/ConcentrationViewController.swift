//
//  ViewController.swift
//  Concentration
//
//  Created by jeffomidvaran on 2/24/20.
//  Copyright © 2020 jeffomidvaran. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController
{
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    private(set) var flipCount: Int = 0 {
        didSet{
            updateFlipCountLabel()
        }
    }
   
    
    func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
        .strokeWidth: 5.0,
        .strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    
    var numberOfPairsOfCards: Int { return (cardButtons.count + 1) / 2 }
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    private var emojiChoices = "🦇🙀😈🍭🍬🍎😱👻🎃"
    private var emoji = [Card: String]()
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card was not in cardButtons")
        }
    }
    

    private func updateViewFromModel() {
        if cardButtons != nil  {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: .normal)
                    button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                } else {
                    button.setTitle("", for: .normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : .blue
                }
            }
        }
    }
    
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex,
                                                       offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
    }
}
