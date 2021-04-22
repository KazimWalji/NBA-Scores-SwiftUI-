//
//  ContentView.swift
//  NBA Scores
//
//  Created by Kazim Walji on 4/21/21.
//

import SwiftUI
    struct ContentView: View {
        let timer = Timer.publish(every: 10, on: .init(), in: .common).autoconnect()
        @State private var games = NbaData.getGames()
        let width =  UIScreen.main.bounds.size.width
        var body: some View {
            NavigationView {
                List {
                    ForEach(games, id: \.self) { game in
                        VStack(alignment: .center) {
                            VStack(spacing: 12) {
                                HStack(spacing: 20) {
                                    Image(uiImage: game.homeImage).resizable()
                                        .frame(width: 36.0, height: 36.0)
                                    Text(String(game.homeScore)).font(.system(size: 25.0))
                                }
                                HStack(spacing: 20) {
                                    Image(uiImage: game.awayImage).resizable()
                                        .frame(width: 36.0, height: 36.0)
                                    Text(String(game.awayScore)).font(.system(size: 25.0))
                                }
                            }
                            if (game.inProgress) {
                                VStack(spacing: 0) {
                                    Text(game.clock).font(.system(size: 15.0))
                                    Text("Quarter  \(game.quarter)").font(.system(size: 20.0))
                                }
                            } else {
                                VStack(spacing: 10) {
                                    Text(game.description).font(.system(size: 20.0))
                                }
                            }
                            
                        }.frame(width: width)
                    }
                }.onReceive(timer, perform: { _ in
                    if games != NbaData.getGames() {
                        games = NbaData.getGames()
                    }
                })
                .navigationTitle("Games")
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    struct GameUI: View {
        var game: Game
        var body: some View {
            VStack {
                VStack(spacing: 12) {
                    HStack(spacing: 20) {
                        Image(uiImage: game.homeImage).resizable()
                            .frame(width: 36.0, height: 36.0)
                        Text(String(game.homeScore)).font(.system(size: 25.0))
                    }
                    HStack(spacing: 20) {
                        Image(uiImage: game.awayImage).resizable()
                            .frame(width: 36.0, height: 36.0)
                        Text(String(game.awayScore)).font(.system(size: 25.0))
                    }
                }
                if (game.inProgress) {
                    VStack(spacing: 0) {
                        Text(game.clock).font(.system(size: 15.0))
                        Text("Quarter  \(game.quarter)").font(.system(size: 20.0))
                    }
                } else {
                    VStack(spacing: 10) {
                        Text(game.description).font(.system(size: 20.0))
                    }
                }
                
            }
        }
    }
