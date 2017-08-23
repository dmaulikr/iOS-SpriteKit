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
    
    override func didMove(to view: SKView) {
        
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
            
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        }
        
        
        
        override func update(_ currentTime: TimeInterval) {
            // Called before each frame is rendered
        }
}