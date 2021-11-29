//
//  ContentView.swift
//  FactofNumbers
//
//  Created by xunruan on 2021-11-27.
//

import SwiftUI

struct MathLine: Decodable {
    var first: Int
    var second: Int
    var operation: String
    var expression: String
    var answer: Int
}

struct ContentView: View {
    let urlString = "https://x-math.herokuapp.com/api/random"
    @State var userInput = ""
    @State var fact = "loading"
    @State var mathLine: MathLine?
    @State var promptInfo: String? = nil
    @State var loadingNext = false
    @State var textWidth: CGFloat = 300
    @State var formulaPosition: CGFloat = -300
    var body: some View {
        ZStack {
            Color.yellow
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if let mathLine = mathLine {
                    Text(mathLine.expression)
                        .modifier(DiagonalFloatingText())
                    
                    Spacer()
                    TextField("Result", text: $userInput)
                        .colorMultiply(loadingNext ? .gray : .white)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
//                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .disabled(loadingNext)
                        .animation(.default, value: loadingNext)
                    
                    
                    
                    if let promptInfo = promptInfo {
                        Text(promptInfo)
                    }
                    
                    Button {
                        // MARK: Confirm the answer
                        if userInput.isEmpty {
                            withAnimation {
                                promptInfo = "Please enter your answer"
                            }
                        }
                        else {
//                            withAnimation {
                                loadingNext = true
//                            }
                            if Int(userInput) == mathLine.answer {
                                withAnimation {
                                    
                                    promptInfo = "Congratulations"
                                }
                            }
                            else {
                                withAnimation {
                                    promptInfo = "Wrong answer"
                                    
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                loadData()
                               
                                withAnimation {
                                    self.loadingNext = false
                                    self.userInput = ""
                                    self.promptInfo = nil
                                }
                            }
                            
                        }
                        
                    } label: {
                        Text("Confirm")
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: 30)
                    }
                    .buttonStyle(.bordered)
                    
                    .colorMultiply(loadingNext ? .gray : .white)
                    .disabled(loadingNext)
                    
                }
                else {
                    Text("Loading")
                }
                
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    func loadData() {
        let task = URLSession.shared.dataTask(with: URL(string: urlString)!) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    mathLine = try! JSONDecoder().decode(MathLine.self, from: data)
                    
                    
                }
            }
            else {
                DispatchQueue.main.async {
                    fact = error.debugDescription
                    
                }
            }
        }
        task.resume()
    }
    
    
}

struct DiagonalFloatingText: ViewModifier {
    @State var textWidth: CGFloat = 300
    @State var startPositionX: CGFloat = -300
    @State var startPositionY: CGFloat = CGFloat.random(in: 0...UIScreen.main.bounds.height)
    let resetPosTimer = Timer.publish(every: 5, on: .main, in: .default).autoconnect()
    func body(content: Content) -> some View {
        content
            .font(.system(size: 80))
            .padding()
//                        .rotationEffect(.degrees(-30))
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
        withAnimation(.linear(duration: 4)) {
            startPositionX = UIScreen.main.bounds.width + textWidth
            startPositionY = UIScreen.main.bounds.height - startPositionY
        }
    }
    
    func resetPosition() {
        startPositionX = -300
        startPositionY = CGFloat.random(in: 0...UIScreen.main.bounds.height)
        
    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mathLine: .init(first: 1, second: 2, operation: "+", expression: "1 + 1", answer: 2))
    }
}
