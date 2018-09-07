//
//  UpgradesScene.swift
//  Practice Game 1
//
//  Created by Michael Moore on 7/21/18.
//  Copyright © 2018 Michael Moore. All rights reserved.
//

import SceneKit
import SpriteKit
import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let backButton = UIButton(frame: CGRect(x: 50, y: 1200, width: 100, height: 75))


class UpgradesScene: SKScene {
    
    
    
    let coinsLabel = UILabel(frame: CGRect(x: 200, y: 100, width: 500, height: 100))
    
    override func didMove(to: SKView) {
        scene?.backgroundColor = UIColor.black
        loadCoinsLabel()
        loadBackButton()
    }
    
    private func loadCoinsLabel() {
        coinsLabel.center = CGPoint(x: screenWidth/1.25, y: screenHeight/20)
        coinsLabel.textAlignment = NSTextAlignment.center
        coinsLabel.font = UIFont(name: "Helvetica", size: 24)
        coinsLabel.textColor = UIColor.yellow
        coinsLabel.text = "Coins: \(GameScene.totalCoins)"
        self.view?.addSubview(coinsLabel)
    }
    
    private func loadBackButton() {
        backButton.frame = CGRect(x: 10, y: 625, width: 50, height: 32.5)
        backButton.backgroundColor = UIColor.green
        backButton.titleLabel?.font = UIFont(name: "Helvetica", size: 12)
        backButton.setTitle("<- Back", for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(backButton)
        
    }
    
    @objc func backButtonPressed(sender: UIButton!) {
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
    
    override func willMove(from: SKView) {
        coinsLabel.removeFromSuperview()
        backButton.removeFromSuperview()
    }
}
