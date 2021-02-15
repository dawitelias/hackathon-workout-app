//
//  Feedback.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/6/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

import SwiftUI
import MessageUI

struct Feedback: View {

    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false

    var body: some View {

        VStack(alignment: .center, spacing: 100) {

            Spacer()

            Text(Strings.feedbackDescription)
                .font(.callout)
                .padding()
                .lineLimit(nil)

            if MFMailComposeViewController.canSendMail() {

                Button(action: {

                    isShowingMailView.toggle()

                }, label: {

                    ZStack {

                        RoundedRectangle(cornerRadius: buttonCornerRadius)
                            .background(Color.blue)

                        Text(Strings.submitFeedback)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                    }
                    .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
                    .cornerRadius(buttonCornerRadius)

                })
                .buttonStyle(DefaultButtonStyle())

            } else {

                Text(Strings.cantSendEmail)

            }

            Spacer()

        }
        .sheet(isPresented: $isShowingMailView) {

            MailView(result: self.$result)

        }
        .navigationBarTitle(Strings.feedback)

    }

    private let buttonCornerRadius: CGFloat = 10
    private let buttonWidth: CGFloat = 300
    private let buttonHeight: CGFloat = 50

}

extension Feedback {

    private struct Strings {

        public static var submitFeedback: String {
            NSLocalizedString("com.okapi.feedback.submitFeedback", value: "Submit feedback", comment: "Submit feedback")
        }

        public static var feedback: String {
            NSLocalizedString("com.okapi.feedback.feedback", value: "Feedback", comment: "Feedback page title")
        }

        public static var cantSendEmail: String {
            NSLocalizedString("com.okapi.feedback.cantsendemail", value: "Can't send emails from this device.", comment: "Text that the user can't send email from their device.")
        }

        public static var feedbackDescription: String {
            NSLocalizedString(
                "com.okapi.feedback.feedbackDescription",
                value: "Did you find a bug 🐛, or mabye you have an idea for a shiny new feature 🌟! Either way, we'd love to hear your feedback!",
                comment: "How to give feedback description.")
        }

    }

}

struct Feedback_Previews: PreviewProvider {

    static var previews: some View {

        Feedback()

    }

}
