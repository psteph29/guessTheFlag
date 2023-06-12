//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Paige Stephenson on 5/30/23.
//

import SwiftUI


struct ContentView: View {
    @State private var showingScore = false
    @State private var showingResults = false
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    @State private var questionCounter = 1

    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var selectedFlag = -1
//    by default this means no flag selected
    
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    
    var body: some View {

        ZStack {
            //   LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
            RadialGradient(stops: [
                .init(color: Color(red: 0.1,green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                VStack {
                   
                    VStack(spacing: 15.0) {
                        VStack {
                            Text("Tap the flag of").font(.subheadline.weight(.heavy))
                                .foregroundStyle(.secondary)
                            Text(countries[correctAnswer]).font(.largeTitle.weight(.semibold))

                        }
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                                .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.75)
//                                .saturation(selectedFlag == -1 || selectedFlag == number ? 1 : 0)
                                .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 3)
                            
                            
                                .animation(.default, value: selectedFlag)
                            
                        }
                    }
                }
                
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
                
        } message: {
            Text("Your score is \(score)")
        }
        
        .alert("Game over!", isPresented: $showingResults) {
            Button("Start Again", action: newGame)
                
        } message: {
            Text("Your final score was \(score)")
        }
    }

    
   
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            let theirAnswer = countries[number]
            let needsThe = ["UK", "US"]
            
            if needsThe.contains(theirAnswer) {
                scoreTitle = "Wrong!\n That is the flag of the \(theirAnswer)"
            } else {
                scoreTitle = "Wrong!\n That is the flag of \(theirAnswer)"
            }
            if score > 0 {
                score -= 1
            }
        }
            
            if questionCounter == 8 {
                showingResults = true
            } else {
                
                showingScore = true
            }
        }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
        selectedFlag = -1
    }
   
    func newGame() {
        questionCounter = 0
        score = 0
        countries = Self.allCountries
        askQuestion()
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
