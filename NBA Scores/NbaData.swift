//
//  NbaData.swift
//  test
//
//  Created by Kazim Walji on 4/20/21.
//

import Foundation
import UIKit

struct gameHash: Hashable {
    let gameName: String
    let id: String
    let quarter: Int
    var homeScore: Int
    var awayScore: Int
    var inProgress : Bool
    var time: Double
    var description: String
    let homeImage: UIImage
    let awayImage: UIImage
    var score: Int
    var clock: String
}
public struct NbaData {
    static func bestGame() -> Game? {
        var games: [Game] = []
        if let events = getData() {
            for event in events {
                if let id = event["id"] {
                    let gameData = getGameData(id: id as! String)
                    games.append(Game(event: gameData!))
                }
            }
        }
        var liveGames: [Game] = []
        for game in games {
            if game.inProgress && game.quarter > 2 {
                liveGames.append(game)
            }
        }
        if liveGames.count > 0 {
            games = liveGames
        }
        var bestGame: Game?
        var bestScore = 1000
        for game in games {
            if game.score < bestScore {
                bestGame = game
                bestScore = game.score
            }
        }
        bestGame?.printGame()
        return bestGame ?? nil
    }
    
    static func getGames() -> [gameHash] {
        var games: [Game] = []
        if let events = getData() {
            for event in events {
                if let id = event["id"] {
                    let gameData = getGameData(id: id as! String)
                    games.append(Game(event: gameData!))
                }
            }
        }
        var liveGames: [Game] = []
        for (i,game) in games.enumerated() {
            if game.inProgress && game.quarter > 2 {
                liveGames.append(game)
                games.remove(at: i)
            }
        }
        if liveGames.count > 0 {
            games = liveGames + games
        }
        var gamesHashable: [gameHash] = []
        for game in games {
            gamesHashable.append(gameHash(gameName: game.gameName, id: game.id, quarter: game.quarter, homeScore: game.homeScore, awayScore: game.awayScore, inProgress: game.inProgress, time: game.time, description: game.description, homeImage: game.homeImage, awayImage: game.awayImage, score: game.score, clock: game.clock))
        }
        return gamesHashable
    }
    
    static func getData() -> [[String:Any]]? {
        do {
            if let url = URL(string: "http://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard") {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String : Any] {
                    let events = object["events"] as! [[String:Any]]
                    return events
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func getGameData(id : String) -> [String:Any]? {
        var events: [String : Any]
        do {
            let domain = "http://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard/" + id
            if let url = URL(string: domain) {
                let data = try Data(contentsOf: url)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String : Any] {
                    events = object
                    return events
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
