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
    var coinMan: SKSpriteNode?
    var ground: SKSpriteNode?
    var ceiling: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    
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
        
        
        
        coinTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.createCoin()
        })
        
       
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        score += 1
        scoreLabel?.text = "Score: \(score)"
        
        if contact.bodyA.categoryBitMask == coinCategory {
            

            contact.bodyA.node?.removeFromParent()

        }
        
        if contact.bodyB.categoryBitMask == coinCategory {
            
            contact.bodyB.node?.removeFromParent()
            
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        coinMan?.physicsBody?.applyForce(CGVector(dx: 0, dy: 10000))
        
        
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
