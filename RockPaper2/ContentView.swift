    //
    //  ContentView.swift
    //  RockPaper2
    //
    //  Created by mostafa on 08/08/2022.
    //

import SwiftUI

struct HandShape: Equatable {
    var shape: String
    var opacity: Double = 1.0
    var scale: Double = 1.0
    var background: Color = .white
}


struct ContentView: View {
    @State private var shapes = [HandShape(shape: "✋"), HandShape(shape: "✊"), HandShape(shape: "✌️")]
    @State private var selected = Int.random(in: 0...2)
    @State private var score = 0
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var startedPlay = true
    @State private var timeChange = 0.0
    @State private var rounds = 0
    @State private var appScore = 0
    
    var body: some View {
        
        VStack {
            
            Text("Rounds: \(rounds)")
                .font(.largeTitle.bold())
            
            Spacer()
            
            VStack(spacing: 40) {
                
                Text("Score: \(appScore)")
                    .font(.largeTitle.bold())
                
                Text(shapes[selected].shape)
                    .font(.system(size: 100))
                    .rotationEffect(.degrees(180))
                
                HStack {
                    ForEach(0..<3) { i in
                        Button(shapes[i].shape) {
                            selectShape(num: i)
                        }
                        .font(.system(size: 80))
                        .disabled(!startedPlay)
                        .opacity(shapes[i].opacity)
                        .scaleEffect(shapes[i].scale)
                        .animation(.default, value: shapes)
                        .padding(10)
                        .background(shapes[i].background)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        
                        
                    }
                }
                Text("Score: \(score)")
                    .font(.largeTitle.bold())
                
            }
            
            
            Spacer()
            
            Button("Restart") {
                score = 0
                rounds = 0
                appScore = 0
            }
            .font(.largeTitle.bold())
            
            Spacer()
            
        }.alert(alertTitle, isPresented: $showAlert) {
            Button("Continue") {
                shapes = [HandShape(shape: "✋"), HandShape(shape: "✊"), HandShape(shape: "✌️")]
            }
        }
        
        
    }
    
    
    
    func isWinner(app: String, human: String) -> Bool? {
        guard app != human else {return nil}
        if app == "✋" {
            return human == "✌️"
        } else if app == "✌️" {
            return human == "✊"
        } else {
            return human == "✋"
        }
    }
    
    
    func selectShape(num: Int) {
        rounds += 1
        timeChange = 0.0
        startedPlay.toggle()
        for i in 0...Int.random(in: 7...9) {
            Timer.scheduledTimer(withTimeInterval: 0.2 * timeChange, repeats: false) { _ in
                selected = i % 3
                
            }
            timeChange += 1
        }
        
        
        Timer.scheduledTimer(withTimeInterval: 0.2 * timeChange, repeats: false) { _ in
            startedPlay.toggle()
            let shouldWin = isWinner(app: shapes[selected].shape, human: shapes[num].shape)
            if shouldWin == true {
                alertTitle = "You Won!"
                score += 1
                shapes[num].background = .green
            } else if shouldWin == false{
                alertTitle = "You lost!"
                shapes[num].background = .red
                appScore += 1
                
            } else {
                alertTitle = "Draw!"
            }
        }
        Timer.scheduledTimer(withTimeInterval: 0.2 * timeChange + 1, repeats: false) { _ in
            showAlert = true
        }
        
        for i in 0..<shapes.count {
            if i == num {
                shapes[i].scale = 1.2
                shapes[i].opacity = 1.0
            } else {
                shapes[i].scale = 0.8
                shapes[i].opacity = 0.25
            }
            
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
