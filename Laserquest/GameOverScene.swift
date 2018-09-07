//
//  GameOverScene.swift
//  Practice Game 1
//
//  Created by Michael Moore on 7/20/18.
//  Copyright © 2018 Michael Moore. All rights reserved.
//

import SceneKit
import SpriteKit
import UIKit

class GameOverScene: SKScene {
    
    let mainMenuButton = UIButton()
    let playAgainButton = UIButton()
    let gameOverLabel = UILabel(frame: CGRect(x: 100, y: UIScreen.main.bounds.height/4, width: UIScreen.main.bounds.width, height: 41))
    let yourScoreLabel = UILabel(frame: CGRect(x: 100, y: UIScreen.main.bounds.height/2, width: UIScreen.main.bounds.width, height: 41))
    let highScoreLabel = UILabel(frame: CGRect(x: 100, y: UIScreen.main.bounds.height/2, width: UIScreen.main.bounds.width, height: 41))
    let totalCoinsLabel = UILabel(frame: CGRect(x: 100, y: UIScreen.main.bounds.height/4, width: UIScreen.main.bounds.width, height: 41))

    override func didMove(to: SKView) {
        scene?.backgroundColor = UIColor.black
        loadGameOverLabel()
        loadYourScoreLabel()
        loadHighScoreLabel()
        loadTotalCoinsLabel()
        loadPlayAgainButton()
        loadMainMenuButton()
    }
    
    private func loadMainMenuButton() {
        mainMenuButton.frame = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/1.5, width: UIScreen.main.bounds.width/2 - 5, height: 100)
        mainMenuButton.backgroundColor = UIColor.green
        mainMenuButton.layer.borderColor = UIColor.black.cgColor
        mainMenuButton.titleLabel?.font = UIFont(name: "Helvetica", size: 24)
        mainMenuButton.setTitle("MAIN MENU", for: UIControlState.normal)
        mainMenuButton.addTarget(self, action: #selector(mainMenuButtonPressed), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(mainMenuButton)
        
    }
    
    @objc func mainMenuButtonPressed(sender: UIButton!) {
        if let view = self.view {
            
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "MainMenuScene") {
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
        }
    }
    
    
    private func loadPlayAgainButton() {
        playAgainButton.frame = CGRect(x: UIScreen.main.bounds.width/UIScreen.main.bounds.width, y: UIScreen.main.bounds.height/1.5, width: UIScreen.main.bounds.width/2 - 5, height: 100)
        playAgainButton.backgroundColor = UIColor.green
        playAgainButton.layer.borderColor = UIColor.black.cgColor
        playAgainButton.titleLabel?.font = UIFont(name: "Helvetica", size: 24)
        playAgainButton.setTitle("PLAY AGAIN", for: UIControlState.normal)
        playAgainButton.addTarget(self, action: #selector(playAgainButtonPressed), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(playAgainButton)
        
    }
    
    @objc func playAgainButtonPressed(sender: UIButton!) {
        if let view = self.view {
            
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
        }
    }
    
    private func loadGameOverLabel() {
        gameOverLabel.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/4)
        gameOverLabel.textAlignment = NSTextAlignment.center
        gameOverLabel.font = UIFont(name: "Helvetica", size: 48)
        gameOverLabel.textColor = UIColor.green
        gameOverLabel.text = "GAME OVER..."
        self.view?.addSubview(gameOverLabel)
    }
    
    private func loadYourScoreLabel() {
        yourScoreLabel.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3)
        yourScoreLabel.textAlignment = NSTextAlignment.center
        yourScoreLabel.font = UIFont(name: "Helvetica", size: 36)
        yourScoreLabel.textColor = UIColor.green
        yourScoreLabel.text = "Your Score: \(GameScene.currentScore)"
        self.view?.addSubview(yourScoreLabel)
    }
    
    private func loadHighScoreLabel() {
        highScoreLabel.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2.5)
        highScoreLabel.textAlignment = NSTextAlignment.center
        highScoreLabel.font = UIFont(name: "Helvetica", size: 24)
        highScoreLabel.textColor = UIColor.green
        highScoreLabel.text = "High Score: \(GameScene.highScore)"
        self.view?.addSubview(highScoreLabel)
    }
    
    private func loadTotalCoinsLabel() {
        totalCoinsLabel.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        totalCoinsLabel.textAlignment = NSTextAlignment.center
        totalCoinsLabel.font = UIFont(name: "Helvetica", size: 36)
        totalCoinsLabel.textColor = UIColor.yellow
        totalCoinsLabel.text = "Total Coins: \(GameScene.totalCoins)"
        self.view?.addSubview(totalCoinsLabel)
    }
    
    override func willMove(from: SKView) {
        gameOverLabel.removeFromSuperview()
        totalCoinsLabel.removeFromSuperview()
        highScoreLabel.removeFromSuperview()
        yourScoreLabel.removeFromSuperview()
        playAgainButton.removeFromSuperview()
        mainMenuButton.removeFromSuperview()
    }
}

