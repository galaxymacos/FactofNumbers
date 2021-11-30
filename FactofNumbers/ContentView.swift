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
    
    func operationDescription(operation: String) -> String {
        if operation == "+" {
            return "plus"
        }
        else if operation == "-" {
            return "minus"
        }
        else if operation == "*" {
            return "multiply"
        }
        else if operation == "/" {
            return "devide"
        }
        fatalError("Operation is not equalvalent to either \"+\", \"-\", \"*\", \"/\"")
    }
    
    /// Return one of the description in plain English of the current expression
    /// - Parameter operation: "+", "-", "*" or "-"
    /// - Returns: A random description
    func randomDescription() -> String {
        var descriptions: [String] = []
        switch operation {
        case "+":
            descriptions.append("\(first) + \(second) = ?")
            descriptions.append("\(first) plus \(second) is equal to ?")
            descriptions.append("Add \(first) to \(second) and you have ? in all.")
            descriptions.append("The sum of \(first) and \(second) is ?")
        case "-":
            descriptions.append("\(first) minus \(second) equals ?")
            descriptions.append("\(first) minus \(second) is equal to ?")
            descriptions.append("\(first) take away \(second) equals ?")
            descriptions.append("The difference between \(first) and \(second) is ?")
        case "*":
            descriptions.append("\(first) multiplied by \(second) equals ?")
            descriptions.append("\(first) times \(second) equals ?")
            descriptions.append("\(first) multiplied by \(second) is equal to ?")
            descriptions.append("\(first) times \(second) is equal to ?")
        case "/":
            descriptions.append("\(first) divided by \(second) equals ?")
            descriptions.append("\(first) devided by \(second) is equal to ?")
        default:
            print("Nothing")
        }
        
        return descriptions.randomElement()!
    }
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
    @State var expressionFilter = ExpressionFilter()
    @State var quizAnswered = 0
    @State var quizTotal = 0
    
    @State var showFilter = false
    var body: some View {
        ZStack {
            Color.yellow
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("Correctness")
                        .padding([.leading], 28)
                        .padding([.top], 10)
                    Spacer()
                    Text("\(quizAnswered) / \(quizTotal)")
                        .padding([.trailing], 60)
                        .padding([.top], 10)
                }
                Spacer()
            }
            if let mathLine = mathLine {
                if !loadingNext {
                    Text(mathLine.randomDescription())
                        .diagonalFloatingText()
                        .edgesIgnoringSafeArea(.all)
                }
            }
            VStack {
                if let mathLine = mathLine {
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
                            quizTotal += 1
                            if Int(userInput) == mathLine.answer {
                                withAnimation {
                                    quizAnswered += 1
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
        .navigationTitle("Practice your Math")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            HStack {
                Button {
                    quizTotal += 1
                    loadData()
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
                
                Button {
                    showFilter = true
                } label: {
                    Label("Filter", systemImage: "square.3.stack.3d.middle.filled")
                }
            }
            
        }
        .sheet(isPresented: $showFilter, onDismiss: {
            print("Dismiss")
            loadData()
        }) {
            FilterView(expressionFilter: $expressionFilter)
        }
    }
    
    
    func loadData() {
        let targetURLString = expressionFilter.randomURL()
        let task = URLSession.shared.dataTask(with: URL(string: targetURLString)!) { data, response, error in
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView(mathLine: .init(first: 1, second: 2, operation: "+", expression: "1 + 1", answer: 2))
        }
    }
}
