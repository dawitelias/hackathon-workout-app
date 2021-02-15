//
//  CompleteSegmentHeader.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/10/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct CompleteSegmentHeader: View {

    var body: some View {
        
        VStack {
            
            Text(Strings.tapAnotherPoint)
                .padding()
                .foregroundColor(Color(UIColor.secondaryLabel))
        }
    }

}

// MARK: Strings and extensions
//
extension CompleteSegmentHeader {
    
    private struct Strings {

        public static var tapAnotherPoint: String {
            NSLocalizedString("com.okapi.completeSegmentHeader.tap", value: "(tap another point along the route to complete the segment)", comment: "text telling user to select another route point")
        }
    }
}

// MARK: Previews
//
struct CompleteSegmentHeader_Previews: PreviewProvider {
    static var previews: some View {
        CompleteSegmentHeader()
    }
}
