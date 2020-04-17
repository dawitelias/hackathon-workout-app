//
//  ChuckNorris.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/16/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation

class ChuckNorris {
    static func getRandomChuckNorrisQuote() -> String {

        let chuckNorrisQuotes = [
            "When the boogie man goes to sleep he checks his closet for me.",
            "I don't initiate violence, I retaliate.",
            "Violence is my last option.",
            "If I wanted your opinion, I'd beat it outta ya. - Walker Texas Ranger",
            "In 1968, I fought and won the world middleweight karate championship by defeating the world's top fighters. I then held that title until 1974, when I retired undefeated.",
            "A lot of times people look at the negative side of what they feel they can't do. I always look on the positive side of what I can do.",
            "Whatever luck I had, I made. I was never a natural athlete, but I paid my dues in sweat and concentration and took the time necessary to learn karate and become world champion.",
            "I've got a bulletin for you, folks. I am no superman. I realize that now, but I didn't always.",
            "T.E.A.M. = Together Everyone Achieves More.",
            "Run while you still have the chance.",
            "The 3 key components for success are as follows: Psychological Preparedness Physical Conditioning Mental Toughness",
            "Running from your fear can be more painful than facing it, for better or worse.",
            "The only time you lose at something is when you don't learn from that experience."
        ]

        let numberOfChuckNorrisQuotes = chuckNorrisQuotes.count
        let randomQuoteIndex = Int.random(in: 0 ... numberOfChuckNorrisQuotes - 1)
        return "\(chuckNorrisQuotes[randomQuoteIndex]) - Chuck Norris"
    }
}
