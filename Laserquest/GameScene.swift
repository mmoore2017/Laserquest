//
//  GameScene.swift
//  Practice Game 1
//
//  Created by Michael Moore on 7/16/18.
//  Copyright © 2018 Michael Moore. All rights reserved.
//

import CoreMotion
import SpriteKit
import GameplayKit

enum SequenceType:Int {
    case oneGreen, oneCoin, twoGreen, twoGreenAndCoin, threeGreenAndCoin, fourGreen
}

class GameScene: SKScene {
    static let defaults = UserDefaults.standard
    
    static var totalCoins = GameScene.defaults.integer(forKey: "Total Coins")
    static var sensitivity:Double = GameScene.defaults.double(forKey: "Sensitivity")
    static var highScore = GameScene.defaults.integer(forKey: "High Score")
    static var currentScore = 0

    
    var gameEnded = false
    var coins = 0
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    var enemyArray = [SKSpriteNode]()
    var coinArray = [SKSpriteNode]()
    var motionManager: CMMotionManager!
    var shotArray = [SKSpriteNode]()
    var touched: Bool!
    var touchLocation: CGPoint!
    var gameScore: SKLabelNode!
    var playerHealth: SKLabelNode!
    var player: SKSpriteNode!
    var sequencePosition = 0
    var sequence: [SequenceType]!
    var nextSequenceQueued = true
    var popupTime = 1.00
    var greenAlienSpeed:CGFloat = -5.00


    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var health = 1 {
        didSet {
            playerHealth.text = "Health: \(health)"
        }
    }

    override func didMove(to view: SKView) {
        background1 = SKSpriteNode(imageNamed: "blackness.jpg")
        background1.size.width = frame.width
        background1.size.height = frame.height + 25
        background1.position = CGPoint(x: 375, y: 667)
        background1.blendMode = .replace
        background1.zPosition = -1
        addChild(background1)
        background2 = SKSpriteNode(imageNamed: "blackness copy.jpg")
        background2.size.width = frame.width
        background2.size.height = frame.height + 25
        background2.position = CGPoint(x: 375, y: 2001)
        background2.blendMode = .replace
        background2.zPosition = -1
        addChild(background2)
        createPlayer()
        createScore()
        createHealth()
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        sequence = [.oneGreen, .oneGreen, .twoGreen, .twoGreenAndCoin]
        for _ in 0 ... 1000 {
            let nextSequence = SequenceType(rawValue: RandomInt(min: 0, max: 4))!
            sequence.append(nextSequence)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
            self.tossEnemies()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(health <= 0) {
            gameEnded = true
        }
        if(!gameEnded) {
            moveBackground()
            movePlayer()
            
            if(!gameEnded) {
                if(touched == true && touched != nil) {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) { [unowned self] in
//                    self.createLaser()
//                    }
                self.createLaser()
                }
            }
            
            for shot in shotArray {
                if(shot.position.y >= 1300) {
                    destroyLaser(laser: shot)
                } else {
                    moveLaser(thing: shot)
                }
            }
            
            if(enemyArray.count <= 0) {
                if !nextSequenceQueued {
                    DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [unowned self] in
                        self.tossEnemies()
                    }
                    greenAlienSpeed *= 1.02
                    popupTime *= 0.91
                    nextSequenceQueued = true
                }
            }
            
            for alien in enemyArray {
                if(alien.position.y <= 0) {
                    destroyAlien(alien: alien)
                } else {
                    moveGreenAlien(thing: alien)
                }
            }
            
            for coin in coinArray {
                if(coin.position.y <= 0) {
                    destroyCoin(coin: coin)
                } else {
                    moveCoin(thing: coin)
                }
            }
            
            detectPlayerHitCoin()
            detectGreenAlienHitsWithLaser()
            detectPlayerHit()
        } else {
            gameOver()
        }
        
        
    }
    
    func tossEnemies() {
        let sequenceType = sequence[sequencePosition]
        switch sequenceType {
        case .oneGreen:
            createGreenAlien()
        case .oneCoin:
            createCoin()
        case .twoGreen:
            createGreenAlien()
            createGreenAlien()
        case .twoGreenAndCoin:
            createGreenAlien()
            createGreenAlien()
            createCoin()
        case .threeGreenAndCoin:
            createGreenAlien()
            createGreenAlien()
            createGreenAlien()
            createCoin()
        case .fourGreen:
            createGreenAlien()
            createGreenAlien()
            createGreenAlien()
            createGreenAlien()
        }
        
        sequencePosition += 1
        nextSequenceQueued = false
    }
    
    func gameOver() {
        GameScene.currentScore = score
        if(score > GameScene.highScore) {
            GameScene.highScore = score
            GameScene.defaults.set(GameScene.highScore, forKey: "High Score")
        }
        GameScene.totalCoins += coins
        GameScene.defaults.set(GameScene.totalCoins, forKey: "Total Coins")
        scene?.removeAllChildren()
        scene?.removeAllActions()
        if let view = self.view {
            
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameOverScene") {
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                let transition = SKTransition.fade(with: UIColor.white, duration: 2)
                view.presentScene(scene, transition: transition)
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!gameEnded) {
            super.touchesBegan(touches, with: event)
            touched = true
            for touch in touches {
                touchLocation = touch.location(in: self)
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!gameEnded) {
            for touch in touches {
                touchLocation = touch.location(in: self)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!gameEnded) {
            touched = false
        }
    }
    
    func movePlayer() {
        let speed:CGFloat = 10.00 * CGFloat(GameScene.sensitivity)
        if let accelerometerData = motionManager.accelerometerData {
            if(accelerometerData.acceleration.x > 0.00) {
                if(player.position.x < 650) {
                    player.position.x = player.position.x + (CGFloat(accelerometerData.acceleration.x)*speed)
                }
            } else if(accelerometerData.acceleration.x < 0.00) {
                if(player.position.x > 100) {
                    player.position.x = player.position.x + (CGFloat(accelerometerData.acceleration.x)*speed)
                }
            }
        }
    }
    
    func destroyLaser(laser: SKSpriteNode) {
        laser.removeFromParent()
        laser.removeAllActions()
        if let index = shotArray.index(of: laser) {
            shotArray.remove(at: index)
        }
    }
    
    func destroyAlien(alien: SKSpriteNode) {
        alien.removeFromParent()
        alien.removeAllActions()
        if let index = enemyArray.index(of: alien) {
            enemyArray.remove(at: index)
        }
    }
    
    func moveLaser(thing: SKSpriteNode) {
        var dy = 1334 - thing.position.y
        let speed:CGFloat = 0.10
        dy = dy * speed
        thing.position.y += dy
    }
    
    func createLaser() {
        if(shotArray.count >= 1) {
            return
        }
        let laser = SKSpriteNode(imageNamed: "laser.png")
        laser.position = CGPoint(x: player.position.x, y: player.position.y + 50)
        laser.blendMode = .replace
        laser.zPosition = 0
        shotArray.append(laser)
        addChild(laser)
    }
    
    func detectPlayerHit() {
        for alien in enemyArray {
            if((abs(alien.position.x - player.position.x) < 50) && (abs(alien.position.y - player.position.y) < 50)) {
                destroyAlien(alien: alien)
                health -= 1
            }
        }
    }
    
    func detectGreenAlienHitsWithLaser() {
        for alien in enemyArray {
            for shot in shotArray {
                if((abs(alien.position.x - shot.position.x) < 50) && (abs(alien.position.y - shot.position.y) < 50)) {
                    destroyAlien(alien: alien)
                    destroyLaser(laser: shot)
                    score += 1
                }
            }
        }
    }
    
    func detectPlayerHitCoin() {
        for coin in coinArray {
            if((abs(coin.position.x - player.position.x) < 50) && (abs(coin.position.y - player.position.y) < 50)) {
                destroyCoin(coin: coin)
                coins += 1
            }
        }
    }
    
    func moveGreenAlien(thing: SKSpriteNode) {
        thing.position.y += greenAlienSpeed
    }
    
    func createGreenAlien() {
        let alien = SKSpriteNode(imageNamed: "greenAlien.png")
        alien.position = CGPoint(x: RandomCGFloat(min: 100.00, max: 650.00), y: 1500)
        alien.blendMode = .replace
        alien.zPosition = 0
        enemyArray.append(alien)
        addChild(alien)
    }
    
    func createCoin() {
        let coin = SKSpriteNode(imageNamed: "coin.png")
        coin.position = CGPoint(x: RandomCGFloat(min: 100.00, max: 650.00), y: 1500)
        coin.blendMode = .replace
        coin.zPosition = 0
        coinArray.append(coin)
        addChild(coin)
    }
    
    func moveCoin(thing: SKSpriteNode!) {
        let speed:CGFloat = -10.00
        thing.position.y += speed
    }
    
    func destroyCoin(coin: SKSpriteNode!) {
        coin.removeFromParent()
        coin.removeAllActions()
        if let index = coinArray.index(of: coin) {
            coinArray.remove(at: index)
        }
    }
    
    
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "blackness.jpg")
        background.size.width = frame.width
        background.size.height = frame.height + 25
        background.position = CGPoint(x: 375, y: 667)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
    
    func moveBackground()  {
        background1.position.y = background1.position.y - 10
        background2.position.y = background2.position.y - 10


        if (background1.position.y <= -667) {
            background1.position.y = 2001
        }

        if (background2.position.y <= -667) {
            background2.position.y = 2001
        }
    }
    
    
    func createPlayer() {
        player = SKSpriteNode(imageNamed: "player.png")
        player.position = CGPoint(x: 375, y: 120)
        player.blendMode = .replace
        player.zPosition = 0
        addChild(player)
    }
    
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Arial")
        gameScore.text = "Score: \(score)"
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 36
        
        addChild(gameScore)
        gameScore.zPosition = 2
        gameScore.position = CGPoint(x: 550, y: 1250)
    }
    
    func createHealth() {
        playerHealth = SKLabelNode(fontNamed: "Arial")
        playerHealth.text = "Health: \(health)"
        playerHealth.horizontalAlignmentMode = .left
        playerHealth.fontSize = 36
        
        addChild(playerHealth)
        playerHealth.zPosition = 2
        playerHealth.position = CGPoint(x: 25, y: 1250)
    }
}
