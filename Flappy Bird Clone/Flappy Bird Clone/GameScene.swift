//
//  GameScene.swift
//  Flappy Bird Clone
//
//  Created by Alex Wong on 8/22/17.
//  Copyright © 2017 Alex Wong. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    var gameOver = false
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var score = 0
    var timer = Timer()
    
    // create enum for collisions between bird and other objects
    
    enum ColliderType: UInt32 {
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
    
    @objc func makePipes(){
        
        // set the gap between the pipes
        
        let gapHeight = bird.size.height * 4
        
        // randomize the pipes
        
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        
        let pipeOffSet = CGFloat(movementAmount) - self.frame.height / 4
        
        // move pipes to the left
        
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        // add and create the pipe obstacles
        
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        
        pipe1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height / 2 + gapHeight / 2 + pipeOffSet)
        pipe1.run(moveAndRemovePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        
        pipe1.physicsBody?.isDynamic = false
        pipe1.zPosition = -2
        
        pipe1.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(pipe1)
        
        // add the second pipe
        
        let pipeTexture2 = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipeTexture2)
        
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipeTexture2.size().height / 2 - gapHeight / 2 + pipeOffSet)
        pipe2.run(moveAndRemovePipes)
        
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        
        pipe2.physicsBody?.isDynamic = false
        pipe2.zPosition = -2
        
        pipe2.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(pipe2)
        
        // create the gap code to keep score (+1 every time bird passes through the gap)
        
        let gap = SKNode()
        
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffSet)
        
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHeight))
        gap.physicsBody!.isDynamic = false
        
        gap.run(moveAndRemovePipes)
        
        // bird able to pass through gap but also able to detect collision
        gap.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody?.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody?.collisionBitMask = ColliderType.Gap.rawValue
        
        self.addChild(gap)
        
        
        
        
    }
    
    
    // called when there is contact between objects
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if gameOver == false{
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            
            print("Add one to score")
            
            
        } else {
            
            print("We have contact!")
            
            self.speed = 0
            gameOver = true
            
            timer.invalidate()
            
            gameOverLabel.fontName = "Helvetica"
            gameOverLabel.fontSize = 30
            gameOverLabel.text = "Game Over! Tap to play again."
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            
            self.addChild(gameOverLabel)
            
            
        }
        }
        
    }
    
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        setupGame()
        
    }
    
    func setupGame() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
        
        // lets add the bg texture
        
        let backgroundTexture = SKTexture(imageNamed: "bg.png")
        
        // create the illusion that the background is moving to the left
        
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -backgroundTexture.size().width, dy: 0), duration: 8)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: backgroundTexture.size().width, dy: 0), duration: 0)
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i: CGFloat = 0
        
        while i < 3 {
            
            background = SKSpriteNode(texture: backgroundTexture)
            background.position = CGPoint(x: backgroundTexture.size().width * i, y: self.frame.midY)
            background.size.height = self.frame.height
            background.run(moveBGForever)
            background.zPosition = -2
            self.addChild(background)
            
            i += 1
            
            
        }
        
        // now add both bird textures and create the animation of bird flapping then repeat forever
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bird.run(makeBirdFlap)
        
        // add physics interaction to bird i.e. gravity and touch to fly
        
        bird.physicsBody?.isDynamic = false
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        
        // collisions
        bird.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        
        
        self.addChild(bird)
        
        // create the ground
        
        // invisible object, no real images used to create the ground
        let ground = SKNode()
        
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        // not affected by gravity, so won't fall
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 70)
        
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
            bird.physicsBody?.isDynamic = true
            
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        } else {
            
            gameOver = false
            
            score = 0
            
            self.speed = 1
            
            self.removeAllChildren()
            
            setupGame()
            
            
            
        }
        
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
