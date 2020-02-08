//
//  StatsVC.swift
//  MatchTheMembers
//
//  Created by Su Hyang Kim on 2/6/20.
//  Copyright © 2020 Su Hyang Kim. All rights reserved.
//

import UIKit

class StatsVC: UIViewController {
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var mostRecentLabel: UILabel!
    @IBOutlet weak var recentMatchLabel: UIImageView!
    
    var mostRecentList = [String]()
    var results: String!
    var longestStreak: Int!
    var isPaused: Bool!
    weak var gameController: GameVC?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        run()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("it will unpause now")
        gameController!.pause(isPaused)
    }

    func run(){
        showStreak()
        showRecents()
        
    }
    
    func showStreak(){
        streakLabel.text = " \(longestStreak!)"
        streakLabel.sizeToFit()
    }
    
    func showRecents(){
        let results = mostRecentList.joined(separator: "\n\n")
        print(results)
        mostRecentLabel.text = "\(results)"
        mostRecentLabel.sizeToFit()
        mostRecentLabel.center = CGPoint(x: streakLabel.center.x, y: streakLabel.frame.maxY + 140)

    }

}
