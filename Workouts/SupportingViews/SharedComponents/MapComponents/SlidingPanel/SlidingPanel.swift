//
//  SlidingPanel.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/3/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import ArcGIS

struct SlidingPanel<Content: View> : View {

    @GestureState private var dragState = DragState.inactive

    @State var position = SlidingPanelPosition.bottom
    
    @Binding var selectedSegment: [AGSFeature]
    
    var content: () -> Content

    private func getYOffset() -> CGFloat {
        if selectedSegment.count == 1 {
            return SlidingPanelPosition.bottom.rawValue + dragState.translation.height
        } else if selectedSegment.count > 0 {
            return position.rawValue + dragState.translation.height
        } else {
            return UIScreen.main.bounds.height
        }
    }

    var body: some View {

        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        
        return Group {

            Handle()
                .frame(width: 100, height: 100)
                .border(Color.blue)
                .padding()

            content()

        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(UIColor.systemBackground))
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        .offset(y: getYOffset())
        .animation(dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
        .gesture(drag)
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = self.position.rawValue + drag.translation.height
        let positionAbove: SlidingPanelPosition
        let positionBelow: SlidingPanelPosition
        let closestPosition: SlidingPanelPosition
        
        if cardTopEdgeLocation <= SlidingPanelPosition.middle.rawValue {
            positionAbove = .top
            positionBelow = .middle
        } else {
            positionAbove = .middle
            positionBelow = .bottom
        }
        
        if (cardTopEdgeLocation - positionAbove.rawValue) < (positionBelow.rawValue - cardTopEdgeLocation) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }
        
        if verticalDirection > 0 {
            self.position = positionBelow
        } else if verticalDirection < 0 {
            self.position = positionAbove
        } else {
            self.position = closestPosition
        }
    }
}

enum SlidingPanelPosition: CGFloat {
    case hidden = 0
    case top = 120
    case middle = 400
    case bottom = 500
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
