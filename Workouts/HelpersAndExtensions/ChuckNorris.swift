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

class DataDidntLoadQuotes {

    static func getRandomDissapointmentQuote() -> String {
        
        let dissapointmentQuotes = [
            "The best way to avoid disappointment is not to expect anything from software.",
            "Sometimes we create our own heartbreaks through expectation.",
            "Dont blame software for disappointing you, blame yourself from expecting too much from it.",
            "Life is a long preparation for something that never happens.",
            "We all have this perfect picture in our minds of how an app is supposed to be and that's why we all end up being dissapointed.",
            "Suspense is worse than disappointment. -Robert Burns",
            "No expectations, no disappointments.",
            "Silly you, expecting too much from software again.",
            "You may be sad, hurt, angry, mad and dissapointed right now. But you know what? Put on a happy face and move on. It will hurt, but you will survive."
        ]
        
        let numberOfQuotes = dissapointmentQuotes.count
        let randomQuoteIndex = Int.random(in: 0 ... numberOfQuotes - 1)
        return "\(dissapointmentQuotes[randomQuoteIndex])"
    }

}
