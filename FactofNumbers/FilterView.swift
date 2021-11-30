//
//  FilterView.swift
//  FactofNumbers
//
//  Created by xunruan on 2021-11-29.
//

import SwiftUI


struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var expressionFilter: ExpressionFilter
    var body: some View {
        VStack {
            
            Toggle("+", isOn: $expressionFilter.additionToggle)
                .padding(.horizontal, 50)
            Toggle("-", isOn: $expressionFilter.subtractionToggle)
                .padding(.horizontal, 50)
            Toggle("*", isOn: $expressionFilter.multiplicationToggle)
                .padding(.horizontal, 50)
            Toggle("/", isOn: $expressionFilter.divisionToggle)
                .padding(.horizontal, 50)
            HStack {
                Text("Max")
                Spacer()
                TextField("Max", value: $expressionFilter.max, formatter: NumberFormatter(), prompt: Text("\(expressionFilter.max)"))
                    .frame(width: 50)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal, 50)
            HStack {
                Text("Min")
                Spacer()
                TextField("Min", value: $expressionFilter.min, formatter: NumberFormatter(), prompt: Text("\(expressionFilter.min)"))
                    .frame(width: 50)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal, 50)
            
            Button {
                if !expressionFilter.additionToggle && !expressionFilter.subtractionToggle &&
                    !expressionFilter.multiplicationToggle &&
                    !expressionFilter.divisionToggle {
                    expressionFilter.showNotPickedAlert = true
                    return
                }
                else {
                    dismiss()
                }
                
            } label: {
                Text("Finish")
                    .frame(width: 300, height: 30)
            }
            .buttonStyle(.borderedProminent)

        }
        .alert("You haven't picked an expression type", isPresented: $expressionFilter.showNotPickedAlert) {
            Button {
                
            } label: {
                Text("Dismiss")
            }
            
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(expressionFilter: .constant(ExpressionFilter()))
    }
}
