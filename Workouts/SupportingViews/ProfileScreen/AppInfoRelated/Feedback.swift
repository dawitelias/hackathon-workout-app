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
            VStack(spacing: 20) {
                Text("We want to improve the experience of our app so if you found a bug or have an idea for a new feature feel free to drop us a line!")
                    .padding()
                    .lineLimit(nil)
                
                if MFMailComposeViewController.canSendMail() {
                    Button("Feedback") {
                        self.isShowingMailView.toggle()
                    }
                        .foregroundColor(Color(UIColor.label))
                        .font(.title)
                        .padding()
                        .cornerRadius(5)
                    .border(Color(UIColor.label), width: 5)
                } else {
                    Text("Can't send emails from this device")
                }
            }
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: self.$result)
        }
        .navigationBarTitle("How are we doing?")
    }
}

struct Feedback_Previews: PreviewProvider {
    static var previews: some View {
        Feedback()
    }
}
