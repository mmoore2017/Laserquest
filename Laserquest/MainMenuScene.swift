//
//  MainMenuScene.swift
//  Practice Game 1
//
//  Created by Michael Moore on 7/17/18.
//  Copyright © 2018 Michael Moore. All rights reserved.
//

import SpriteKit
import UIKit

class MainMenuScene: SKScene {
    
    /* UI Connections */
//    var buttonPlay: MSButtonNode!
//    var buttonOptions: MSButtonNode!
//    var buttonUpgrades: MSButtonNode!
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let titleLabel = UILabel(frame: CGRect(x: 100, y: 100, width: UIScreen.main.bounds.width, height: 41))
    let playButton = UIButton(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 100))
    let optionsButton = UIButton(frame: CGRect(x: 0, y: 350, width: UIScreen.main.bounds.width, height: 100))
    let upgradesButton = UIButton(frame: CGRect(x: 0, y: 500, width: UIScreen.main.bounds.width, height: 100))




    
    override func didMove(to view: SKView) {
        
        scene?.backgroundColor = UIColor.black
        loadPlayButton()
        loadOptionsButton()
        loadTitleLabel()
        loadUpgradesButton()
    }
    
    private func loadTitleLabel() {
        titleLabel.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/6)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont(name: "Potra", size: 48)
        titleLabel.textColor = UIColor.green
        titleLabel.text = "LASERQUEST"
        self.view?.addSubview(titleLabel)
    }
    
    private func loadPlayButton() {
        playButton.backgroundColor = UIColor.green
        playButton.setTitleColor(UIColor.black, for: .normal)
        playButton.titleLabel?.font = UIFont(name: "Potra", size: 48)
        playButton.setTitle("PLAY", for: UIControlState.normal)
        playButton.addTarget(self, action: #selector(playButtonPressed), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(playButton)
        
    }
    
    private func loadUpgradesButton() {
        upgradesButton.backgroundColor = UIColor.green
        upgradesButton.setTitleColor(UIColor.black, for: .normal)
        upgradesButton.titleLabel?.font = UIFont(name: "Potra", size: 48)
        upgradesButton.setTitle("UPGRADES", for: UIControlState.normal)
        upgradesButton.addTarget(self, action: #selector(upgradesButtonPressed), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(upgradesButton)
        
    }
    
    private func loadOptionsButton() {
        optionsButton.backgroundColor = UIColor.green
        optionsButton.setTitleColor(UIColor.black, for: .normal)
        optionsButton.titleLabel?.font = UIFont(name: "Potra", size: 48)
        optionsButton.setTitle("OPTIONS", for: UIControlState.normal)
        optionsButton.addTarget(self, action: #selector(optionsButtonPressed), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(optionsButton)
        
    }
    
    @objc private func playButtonPressed() {
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
    
    @objc private func optionsButtonPressed() {
        if let view = self.view {
            
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "OptionsScene") {
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
        }
    }
    
    @objc private func upgradesButtonPressed() {
        if let view = self.view {
            
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "UpgradesScene") {
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
        }
    }
    
    override func willMove(from: SKView) {
        playButton.removeFromSuperview()
        optionsButton.removeFromSuperview()
        titleLabel.removeFromSuperview()
        upgradesButton.removeFromSuperview()
    }
    
}
