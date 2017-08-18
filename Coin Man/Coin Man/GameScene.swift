//
//  GameScene.swift
//  Coin Man
//
//  Created by Alex Wong on 8/18/17.
//  Copyright © 2017 Alex Wong. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var coinTimer: Timer?
    var bombTimer: Timer?
    var coinMan: SKSpriteNode?
    var ground: SKSpriteNode?
    var ceiling: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    var yourScoreLabel: SKLabelNode?
    var finalScoreLabel: SKLabelNode?
    
    var score = 0
    
    // create categories for each objects to create the collsion
    
    let coinManCategory: UInt32 = 0x1 << 1
    let coinCategory: UInt32 = 0x1 << 2
    let bombCategory: UInt32 = 0x1 << 3
    let groundAndCeilingCategory: UInt32 = 0x1 << 4
    
    override func didMove(to view: SKView) {
        
        // Create contact delegate
        
        physicsWorld.contactDelegate = self
        
        
        
        
        coinMan = childNode(withName: "coinMan") as? SKSpriteNode
        coinMan?.physicsBody?.categoryBitMask = coinManCategory
        
        
        // who is coin man gonna interact with?
        coinMan?.physicsBody?.contactTestBitMask = coinCategory | bombCategory
        coinMan?.physicsBody?.collisionBitMask = groundAndCeilingCategory
        
        ground = childNode(withName: "ground") as? SKSpriteNode
        ground?.physicsBody?.categoryBitMask = groundAndCeilingCategory
        ground?.physicsBody?.collisionBitMask = coinManCategory
        
        ceiling = childNode(withName: "ceiling") as? SKSpriteNode
        ceiling?.physicsBody?.categoryBitMask = groundAndCeilingCategory
        
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        
        
        
        startTimers()
        
        
    }
    
    func gameOver() {
        scene?.isPaused = true
        
        coinTimer?.invalidate()
        bombTimer?.invalidate()
        
        yourScoreLabel = SKLabelNode(text: "Your Score:")
        yourScoreLabel?.position = CGPoint(x: 0, y: 200)
        yourScoreLabel?.fontSize = 100
        yourScoreLabel?.zPosition = 1
        if yourScoreLabel != nil{
            addChild(yourScoreLabel!)
        }
        
        finalScoreLabel = SKLabelNode(text: "\(score)")
        finalScoreLabel?.position = CGPoint(x: 0, y: 0)
        finalScoreLabel?.fontSize = 200
        finalScoreLabel?.zPosition = 1
        
        if finalScoreLabel != nil{
            addChild(finalScoreLabel!)
        }
        
        let playButton = SKSpriteNode(imageNamed: "play")
        playButton.position = CGPoint(x: 0, y: -200)
        playButton.name = "play"
        playButton.zPosition = 1
        addChild(playButton)
        
        
        
    }
    
    func startTimers() {
        coinTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.createCoin()
        })
        
        bombTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            self.createBomb()
        })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        
        if contact.bodyA.categoryBitMask == coinCategory {
            
            score += 1
            scoreLabel?.text = "Score: \(score)"
            contact.bodyA.node?.removeFromParent()
            
        }
        
        if contact.bodyB.categoryBitMask == coinCategory {
            score += 1
            scoreLabel?.text = "Score: \(score)"
            contact.bodyB.node?.removeFromParent()
            
        }
        
        if contact.bodyA.categoryBitMask == bombCategory {
            contact.bodyA.node?.removeFromParent()
            gameOver()
            
        }
        
        if contact.bodyB.categoryBitMask == bombCategory {
            contact.bodyB.node?.removeFromParent()
            gameOver()
            
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if scene?.isPaused == false{
            coinMan?.physicsBody?.applyForce(CGVector(dx: 0, dy: 10000))
            
        }
            
            let touch = touches.first
            if let location = touch?.location(in: self){
                let theNodes = nodes(at: location)
                
                for node in theNodes {
                    
                    if node.name == "play" {
                        
                        // restart the game
                        
                        score = 0
                        
                        node.removeFromParent()
                        finalScoreLabel?.removeFromParent()
                        yourScoreLabel?.removeFromParent()
                        
                        scene?.isPaused = false
                        scoreLabel?.text = "Score: \(score)"
                        startTimers()

                }
                
            }
        }
    }
    
    func createBomb() {
        
        
        let bomb = SKSpriteNode(imageNamed: "bomb")
        bomb.physicsBody = SKPhysicsBody(rectangleOf: bomb.size)
        bomb.physicsBody?.affectedByGravity = false
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.contactTestBitMask = bombCategory
        bomb.physicsBody?.collisionBitMask = 0
        addChild(bomb)
        
        let maxY = size.height / 2 - bomb.size.height / 2
        let minY = -size.height / 2 + bomb.size.height / 2
        
        let range = maxY - minY
        
        let bombY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        
        bomb.position = CGPoint(x: size.width / 2 + bomb.size.width / 2, y: bombY)
        
        let moveLeft = SKAction.moveBy(x: -size.width - bomb.size.width, y: 0, duration: 4)
        
        
        
        bomb.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
        
        
    }
    
    func createCoin() {
        
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = coinCategory
        coin.physicsBody?.contactTestBitMask = coinManCategory
        coin.physicsBody?.collisionBitMask = 0
        addChild(coin)
        
        let maxY = size.height / 2 - coin.size.height / 2
        let minY = -size.height / 2 + coin.size.height / 2
        
        let range = maxY - minY
        
        let coinY = maxY - CGFloat(arc4random_uniform(UInt32(range)))
        
        coin.position = CGPoint(x: size.width / 2 + coin.size.width / 2, y: coinY)
        
        let moveLeft = SKAction.moveBy(x: -size.width - coin.size.width, y: 0, duration: 4)
        
        
        
        coin.run(SKAction.sequence([moveLeft, SKAction.removeFromParent()]))
        
        
    }
    
    
    
    
}
