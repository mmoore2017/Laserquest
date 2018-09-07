//
//  OptionsScene.swift
//  Practice Game 1
//
//  Created by Michael Moore on 7/18/18.
//  Copyright © 2018 Michael Moore. All rights reserved.
//

import SceneKit
import SpriteKit
import UIKit

class OptionsScene: SKScene {
    
    let backButton = UIButton(frame: CGRect(x: 50, y: 1200, width: 100, height: 75))
    let sensitivityLabel = UILabel(frame: CGRect(x: 100, y: 200, width: 100, height: 41))
    let sensitivitySlider = UISlider(frame: CGRect(x: 30, y: 70, width: 310, height: 31))
    
    
    override func didMove(to: SKView) {
        scene?.backgroundColor = UIColor.black
        loadSlider()
        loadSensitivityLabel()
        loadBackButton()
    }
    
    private func loadBackButton() {
        backButton.frame = CGRect(x: 10, y: 625, width: 50, height: 32.5)
        backButton.backgroundColor = UIColor.green
        backButton.titleLabel?.font = UIFont(name: "Helvetica", size: 12)
        backButton.setTitle("<- Back", for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(backButton)

    }
    
    private func loadSlider() {
        sensitivitySlider.minimumValue = 1
        sensitivitySlider.maximumValue = 10
        sensitivitySlider.tintColor = UIColor.green
        sensitivitySlider.value = GameScene.defaults.float(forKey: "Sensitivity")
        sensitivitySlider.isUserInteractionEnabled = true
        sensitivitySlider.addTarget(self, action: #selector(sensitivitySliderValueDidChange), for: .valueChanged)
        self.view?.addSubview(sensitivitySlider)
    }
    
    private func loadSensitivityLabel() {
        sensitivityLabel.center = CGPoint(x: 190, y: 61)
        sensitivityLabel.textAlignment = NSTextAlignment.center
        sensitivityLabel.font = UIFont(name: "Helvetica", size: 12)
        sensitivityLabel.textColor = UIColor.green
        sensitivityLabel.text = "Sensitivity: \(Int(sensitivitySlider.value))"
        self.view?.addSubview(sensitivityLabel)
    }
    
    @objc func sensitivitySliderValueDidChange(sender: UISlider!) {
        sensitivityLabel.text = "Sensitivity: \(Int(sender.value))"
        GameScene.sensitivity = Double(sender.value)
        GameScene.defaults.set(Double(sender.value), forKey: "Sensitivity")
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
        backButton.removeFromSuperview()
        sensitivityLabel.removeFromSuperview()
        sensitivitySlider.removeFromSuperview()
    }
    
    
}
