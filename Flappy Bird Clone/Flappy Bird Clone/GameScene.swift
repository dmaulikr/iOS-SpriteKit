//
//  GameScene.swift
//  Flappy Bird Clone
//
//  Created by Alex Wong on 8/22/17.
//  Copyright © 2017 Alex Wong. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Properties
    
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    
    
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
        
        self.addChild(pipe1)
        
        // add the second pipe
        
        let pipeTexture2 = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipeTexture2)
        
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipeTexture2.size().height / 2 - gapHeight / 2 + pipeOffSet)
        pipe2.run(moveAndRemovePipes)
        
        self.addChild(pipe2)
        
        
    }
    
    
    override func didMove(to view: SKView) {
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
        
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
            background.zPosition = -1
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
        
        self.addChild(bird)
        
        // create the ground
        
        // invisible object, no real images used to create the ground
        let ground = SKNode()
        
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        // not affected by gravity, so won't fall
        ground.physicsBody?.isDynamic = false
        
        self.addChild(ground)
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        
        // add physics interaction to bird i.e. gravity and touch to fly
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
      
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
        
        
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
