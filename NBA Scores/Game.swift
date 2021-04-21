//
//  Data.swift
//  CloseScores
//
//  Created by Kazim Walji on 4/19/21.
//

import Foundation
import UIKit

class Game {
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
    init(event: [String : Any]) {
        let status = event["status"] as! [String:Any]
        let competitions = event["competitions"] as! [[String:Any]]
        let competitors = competitions[0]["competitors"] as! [[String:Any]]
        let homeTeam = competitors[0]["team"] as! [String:Any]
        let awayTeam = competitors[1]["team"] as! [String:Any]
        let homeUrl = URL(string: homeTeam["logo"] as? String ?? "")
        let awayUrl = URL(string: awayTeam["logo"] as? String ?? "")
        let homeData = try? Data(contentsOf: homeUrl!)
        let awayData = try? Data(contentsOf: awayUrl!)
        self.homeImage = UIImage(data: homeData!)!
        self.awayImage = UIImage(data: awayData!)!
        self.id = event["id"] as? String ?? ""
        self.gameName = event["shortName"] as? String ?? ""
        self.quarter = status["period"] as? Int ?? 0
        self.homeScore = Int(competitors[0]["score"] as? String ?? "0") ?? 0
        self.awayScore = Int(competitors[1]["score"] as? String ?? "0") ?? 0
        self.score = abs(self.homeScore - self.awayScore)
        self.clock = status["displayClock"] as? String ?? ""
        let type = status["type"] as! [String:Any]
        let completed = type["completed"] as? Bool ?? true
        if !completed && status["period"] as! Int > 0 {
            self.inProgress = true
            self.time = type["displayClock"] as? Double ?? 0.0
            self.description = ""
        } else {
            self.inProgress = false
            if self.quarter > 4 {
                self.description = type["description"] as? String ?? ""
            } else {
                var description = type["shortDetail"] as? String ?? ""
                description = String(description.suffix(from: description.firstIndex(of: "-")!))
                description = String(description.suffix(from: String.Index(encodedOffset: 2)))
                self.description = description
            }
            self.time = -1.0
        }
    }
    
    func printGame() {
        print("\(gameName) quarter: \(quarter) score: \(homeScore) vs \(awayScore) live: \(inProgress)")
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
