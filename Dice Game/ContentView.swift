//
//  ContentView.swift
//  Dice Game
//
//  Created by Matheus Araújo on 25/09/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DiceRoolerView()
    }
}

struct DiceRoolerView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var diceNumber = 0
    
    @State var playerOne = 0
    
    @State var playerTwo = 0
    
    @State var currentScore = 0
    
    @State var currentPlayer = 0
    
    @State var attempts: Int = 0
    
    @State var addBorder: Bool = true
    
    @State var showingAlert = false
    
    @State var winner = 0
    
    let diceFacesDark = ["die.face.1.fill", "die.face.2.fill", "die.face.3.fill", "die.face.4.fill", "die.face.5.fill", "die.face.6.fill"]
    
    let diceFacesLight = ["die.face.1", "die.face.2", "die.face.3", "die.face.4", "die.face.5", "die.face.6"]
    
    
    
    
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                
                Text("🐷 GAME").font(.system(size: 40, weight: .heavy, design: .rounded))
                
                Spacer()
                
                HStack(spacing: 60)  {
                    VStack(spacing: 15) {
                        Text("PLAYER 1").font(.system(size: 28, weight: .medium, design: .rounded))
                        
                        Text("P1 SCORE: \(playerOne)").font(.system(size: 20, weight: .medium, design: .rounded))
                    }
                    .padding()
                    .overlay(currentPlayer == 0 ? RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 4) : nil)
                    
                    VStack(spacing: 15) {
                        Text("PLAYER 2").font(.system(size: 28, weight: .medium, design: .rounded))
                        
                        Text("P2 SCORE: \(playerTwo)").font(.system(size: 20, weight: .medium, design: .rounded))
                    }
                    .padding()
                    .overlay(currentPlayer == 1 ? RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 4) : nil)
                }
                
                Spacer()
                
                Image(systemName: colorScheme == .dark ? diceFacesDark[diceNumber] : diceFacesLight[diceNumber])
                    .font(.system(size: 100))
                    .modifier(Shake(animatableData: CGFloat(attempts)))
                
                Text("CURRENT SCORE = \(currentScore)").font(.system(size: 30, weight: .medium, design: .rounded))
                
                Spacer()
                
                VStack(spacing: 20) {
                    
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                        impactMed.impactOccurred()
                        withAnimation(.default){
                            roll()
                        }
                        print("Botão ROLL")
                    }, label: {
                        Text("🎲 Roll")
                    }).buttonStyle(.borderedProminent).font(.largeTitle)
                    
                    
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                        impactMed.impactOccurred()
                        withAnimation(.default){
                            hold()
                        }
                        print("Botão HOLD")
                    } , label: {
                        Text("📥 Hold")
                    }).buttonStyle(.borderedProminent).font(.largeTitle)
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("O PLAYER \(winner + 1) GANHOU!"), message: Text("Beba água car*alho"), dismissButton: .default(Text("REINICIAR")) {
                                new()
                            })
                        }
                    
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                        impactMed.impactOccurred()
                        withAnimation(.default){
                            new()
                        }
                        print("Botão NEW GAME")
                    } , label: {
                        Text("🔄 New Game")
                    }).buttonStyle(.borderedProminent).font(.largeTitle)
                }
            }
        }
        //.ignoresSafeArea(edges: .top)
        
    }
    
    func roll() {
        diceNumber = Int.random(in: 0...5)
        
        if diceNumber == 0 && currentPlayer == 0 {
            currentPlayer = 1
        } else if diceNumber == 0 && currentPlayer == 1 {
            currentPlayer = 0
        }
        
        if diceNumber != 0 {
            currentScore += diceNumber + 1
        } else {
            currentScore = 0
        }
        
        attempts += 1
        
        print("Ultimo dado foi \(diceNumber + 1) para o player \(currentPlayer + 1)")
    }
    
    func hold() {
        if currentScore != 0 && currentPlayer == 0 {
            playerOne += currentScore
            
            currentScore = 0
            
            currentPlayer = 1
        } else if currentScore != 0 && currentPlayer == 1 {
            playerTwo += currentScore
            
            currentScore = 0
            
            currentPlayer = 0
        }
        
        if playerOne >= 100 {
            winner = 0
            showingAlert = true
            currentPlayer = 0
        } else if playerTwo >= 100 {
            winner = 1
            showingAlert = true
            currentPlayer = 1
        }
    }
    
    func new() {
        playerOne = 0
        
        playerTwo = 0
        
        currentScore = 0
        
        diceNumber = 0
        
        currentPlayer = 0
    }
    
    struct Shake: GeometryEffect {  // peguei do stack, não entendo AINDA
        var amount: CGFloat = 10
        var shakesPerUnit = 3
        var animatableData: CGFloat
        
        func effectValue(size: CGSize) -> ProjectionTransform {
            ProjectionTransform(CGAffineTransform(translationX:
                                                    amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
                                                  y: 0))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
