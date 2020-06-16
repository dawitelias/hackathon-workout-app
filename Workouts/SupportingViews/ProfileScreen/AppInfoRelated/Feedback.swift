//
//  Feedback.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/29/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import MessageUI

struct Feedback: View {
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Clever you, you either found a bug or you have a great idea for a new feature! 😃😃😃")
                    .font(.headline)
                    .padding()
                    .lineLimit(nil)

                Text("Either way, we are always happy to hear from the folks who use our app and we want to make it a better experience for you!")
                    .font(.headline)
                    .padding()
                    .lineLimit(nil)
                
                Text("Let us know what we can do by dropping us a line.")
                    .font(.headline)
                    .padding()
                    .lineLimit(nil)
                
                if MFMailComposeViewController.canSendMail() {
                    Button("Drop us a line...") {
                        self.isShowingMailView.toggle()
                    }
                } else {
                    Text("Can't send emails from this device")
                }
            }
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: self.$result)
        }
        .navigationBarTitle("Feedback")
    }
}

struct Feedback_Previews: PreviewProvider {
    static var previews: some View {
        Feedback()
    }
}
