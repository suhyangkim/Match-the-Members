//
//  GameVC.swift
//  MatchTheMembers
//
//  Created by Su Hyang Kim on 2/6/20.
//  Copyright © 2020 Su Hyang Kim. All rights reserved.
//

import UIKit

class GameVC: UIViewController {

    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var answerOneButton: UIButton!
    @IBOutlet weak var answerTwoButton: UIButton!
    @IBOutlet weak var answerThreeButton: UIButton!
    @IBOutlet weak var answerFourButton: UIButton!
    
    var buttons = [UIButton]()
    var answerName = ""
    var correctStreak = false
    var score = 0 {
        didSet{
            scoreLabel.sizeToFit()
            scoreLabel.text = "Score: \(score)"
        }
    }
    var timer = Timer()
    var seconds = 5
    var isTimerRunning = false
    var isPaused = false
    var longestStreak = 0
    var mostRecentList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        run()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if isPaused{
            print("is it paused? \(isPaused)")
            pause(isPaused)
        }
    }
    
    func cameBack(_ pauseBool: Bool){
        self.isPaused = pauseBool
    }


    
    func run(){
        resetTimer()
        roundCorners()
        resetButtons()
        answerName = Constants.names.randomElement()!
        showImage.image = Constants.getImageFor(name: answerName)
        randomizeButtonNames()
        runTimer()
    }

    @IBAction func toStatsScreen(_ sender: Any) {
        if !isPaused{
            pause(isPaused)
        }
        self.performSegue(withIdentifier: "toStatsVC", sender: self)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        pause(isPaused)
    }
    
    func updateList(_ name: String, _ result: String){
        if mostRecentList.count == 3{
            mostRecentList.removeLast()
        }
        mostRecentList.insert("\(name): \(result)", at:0)
    }
    
    func pause(_ pausedBool: Bool = false){
        print(pausedBool)
        isPaused = !isPaused
        print(!pausedBool)
        if !pausedBool{
            disableButtons()
            pauseButton.setImage(UIImage(named: "play-1"), for: .normal)
            isTimerRunning = false
            timer.invalidate()
        } else {
            enableButtons()
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            runTimer()
        }
    }
    
    func checkStreak(){
        if score > longestStreak{
            longestStreak = score
        }
    }
    
    func resetTimer(){
        isTimerRunning = false
        timer.invalidate()
        seconds = 5
        timerLabel.text = "\(seconds)"
    }
    
    func runTimer(){
        isTimerRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        if seconds > 0{
            seconds -= 1
            timerLabel.text = "\(seconds)"
        } else if seconds == 0{
            checkStreak()
            score = 0
            isTimerRunning = false
            timer.invalidate()
            colorCorrect()
        }
    }
    
    func roundCorners(){
        buttons = [answerOneButton, answerTwoButton, answerThreeButton, answerFourButton]
        for button in buttons{
            button.layer.cornerRadius = 25.0
        }
        scoreLabel.layer.cornerRadius = 25.0
    }
    
    func enableButtons(){
        buttons = [answerOneButton, answerTwoButton, answerThreeButton, answerFourButton]
        for button in buttons{
            button.isEnabled = true
        }
    }
    
    func disableButtons(){
        buttons = [answerOneButton, answerTwoButton, answerThreeButton, answerFourButton]
        for button in buttons{
            button.isEnabled = false
        }
    }
    
    func resetButtons(){
        buttons = [answerOneButton, answerTwoButton, answerThreeButton, answerFourButton]
        for button in buttons{
            button.backgroundColor = UIColor.white
            button.setTitleColor(.blue, for: .normal)
            button.isEnabled = true
        }
    }
    
    func randomizeButtonNames(){
        buttons = [answerOneButton, answerTwoButton, answerThreeButton, answerFourButton]
        buttons.shuffle()
        buttons.removeFirst().setTitle(answerName, for: .normal)
        var namesLst = Constants.names
        namesLst.shuffle()
        var answerIndex = namesLst.index(of: answerName)!
        namesLst.remove(at: answerIndex)
        for button in buttons{
            var name = namesLst.removeFirst()
            button.setTitle(name, for: .normal)
        }
    }
    
    @IBAction func ansOneButton(_ sender: Any) {
        tapped(answerOneButton)
    }
    
    
    @IBAction func ansTwoButton(_ sender: Any) {
        tapped(answerTwoButton)
    }
    

    @IBAction func answerThreeButton(_ sender: Any) {
        tapped(answerThreeButton)
    }
    
    @IBAction func ansFourButton(_ sender: Any) {
        tapped(answerFourButton)
    }
    
    func tapped(_ button: UIButton!){
        timer.invalidate()
        disableButtons()
        if button.titleLabel!.text == answerName{
            button.backgroundColor = UIColor(red: 198/255.0, green: 248/255.0, blue: 229/255.0, alpha: 1.0)
            button.setTitleColor(.black, for: .normal)
            updateList(answerName, "Correct")
            score += 1
            checkStreak()
            scoreLabel.sizeToFit()
            correctStreak = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.run()
            }
        } else{
            button.backgroundColor = UIColor(red: 249/255.0, green: 222/255.0, blue: 215/255.0, alpha: 1.0)
            button.setTitleColor(.black, for: .normal)
            checkStreak()
            score = 0
            scoreLabel.sizeToFit()
            correctStreak = false
            colorCorrect()
        }
    }
    
    func colorCorrect(){
        buttons = [answerOneButton, answerTwoButton, answerThreeButton, answerFourButton]
        updateList(answerName, "Incorrect")
        for button in buttons{
            if button.titleLabel!.text == answerName{
                button.backgroundColor = UIColor(red: 198/255.0, green: 248/255.0, blue: 229/255.0, alpha: 1.0)
                button.setTitleColor(.black, for: .normal)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.run()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? StatsVC, segue.identifier == "toStatsVC" {
            destinationVC.longestStreak = longestStreak
            destinationVC.mostRecentList = mostRecentList
            print(mostRecentList)
            destinationVC.isPaused = isPaused
            destinationVC.gameController = self
        }
    }
    
}
