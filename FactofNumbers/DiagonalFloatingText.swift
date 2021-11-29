//
//  DiagonalFloatingText.swift
//  FactofNumbers
//
//  Created by xunruan on 2021-11-29.
//

import Foundation
import SwiftUI

struct DiagonalFloatingText: ViewModifier {
    @State var textWidth: CGFloat = 300
    @State var startPositionX: CGFloat = -300
    @State var startPositionY: CGFloat = CGFloat.random(in: 0...UIScreen.main.bounds.height)
    
    /// This is used to calculate how scale the text it is to face to the direction it is moving
    @State var scale: Double = 0
    let resetPosTimer = Timer.publish(every: 2, on: .main, in: .default).autoconnect()
    func body(content: Content) -> some View {
        content
            .font(.system(size: 50))
            .padding()
            .rotationEffect(.radians(-scale))
            .frame(width: textWidth)
            .position(x: startPositionX, y: startPositionY)
            .onAppear {
                animateFormula()
            }
            .onReceive(resetPosTimer) { _ in
                resetPosition()
                animateFormula()
                print("reset position")
            }
    }
    
    func animateFormula() {
        withAnimation(.linear(duration: 2)) {
            startPositionX = UIScreen.main.bounds.width + textWidth
            startPositionY = UIScreen.main.bounds.height - startPositionY
        }
    }
    
    func resetPosition() {
        startPositionX = -300
        startPositionY = CGFloat.random(in: 0...UIScreen.main.bounds.height)
        scale = (Double(startPositionY / UIScreen.main.bounds.height) - 0.5) * 1.1
    }
    
}

extension View {
    func diagonalFloatingText() -> some View {
        modifier(DiagonalFloatingText())
    }
}
