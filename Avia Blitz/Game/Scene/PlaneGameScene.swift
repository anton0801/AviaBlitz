import Foundation
import SpriteKit
import SwiftUI

class PlaneGameScene: SKScene, SKPhysicsContactDelegate {
    
    private var background: SKSpriteNode!
    
    private var fuelBackIndicator: SKSpriteNode!
    private var plane: SKSpriteNode!
    
    private var boosterFirstField: BoosterFieldNode!
    private var boosterSecondField: BoosterFieldNode!
    private var boosterThirdField: BoosterFieldNode!
    
    private var pauseNode: GamePauseNode!
    
    private var pauseBtn: SKSpriteNode!
    
    private var trasseIndicator: SKSpriteNode!
    
    var rocketSpawnTimer = Timer()
    var boosterSpawnTimer = Timer()
    var starsSpawnTimer = Timer()
    
    var catchesStars: Int = 0
    var cameraSpeed: CGFloat = 0.1
    
    let boosters = ["speed", "fuel_up", "shield"]
    
    var isBoosterSpeedUp = false
    var addedBoosterFuel = false
    var boosterShield = false
    
    var musicOn = true
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 750, height: 1335)
        physicsWorld.contactDelegate = self
        makeBackground()
        makeFuelBack()
        makePlane()
        addUiInterface()
        
        rocketSpawnTimer = .scheduledTimer(timeInterval: 2, target: self, selector: #selector(spawnRocket), userInfo: nil, repeats: true)
        boosterSpawnTimer = .scheduledTimer(timeInterval: 15, target: self, selector: #selector(spawnRandomBooster), userInfo: nil, repeats: true)
        starsSpawnTimer = .scheduledTimer(timeInterval: 3, target: self, selector: #selector(spawnStar), userInfo: nil, repeats: true)
    }
    
    @objc private func spawnStar() {
        if !isPaused {
            let star = SKSpriteNode(imageNamed: "game_point")
            let starY = CGFloat(Int.random(in: 300...1000))
            star.size = CGSize(width: 100, height: 90)
            star.position = CGPoint(x: size.width, y: starY)
            star.physicsBody = SKPhysicsBody(rectangleOf: star.size)
            star.physicsBody?.affectedByGravity = false
            star.physicsBody?.isDynamic = true
            star.physicsBody?.categoryBitMask = 3
            star.physicsBody?.collisionBitMask = 1
            star.physicsBody?.contactTestBitMask = 1
            star.name = "star"
            addChild(star)
            
            let moveAction = SKAction.move(to: CGPoint(x: 0, y: starY), duration: 10)
            star.run(moveAction) {
                star.removeFromParent()
            }
        }
    }
    
    @objc private func spawnRocket() {
        if !isPaused {
            let rocket = SKSpriteNode(imageNamed: "rocket")
            let rocketY = CGFloat(Int.random(in: 300...1000))
            rocket.size = CGSize(width: 140, height: 60)
            rocket.position = CGPoint(x: size.width, y: rocketY)
            rocket.physicsBody = SKPhysicsBody(rectangleOf: rocket.size)
            rocket.physicsBody?.affectedByGravity = false
            rocket.physicsBody?.isDynamic = true
            rocket.physicsBody?.categoryBitMask = 2
            rocket.physicsBody?.collisionBitMask = 1
            rocket.physicsBody?.contactTestBitMask = 1
            rocket.name = "rocket"
            addChild(rocket)
            
            let moveAction = SKAction.move(to: CGPoint(x: 0, y: rocketY), duration: 10)
            rocket.run(moveAction) {
                rocket.removeFromParent()
            }
        }
    }
    
    @objc private func spawnRandomBooster() {
        if !isPaused {
            let randomBooster = boosters.randomElement() ?? "speed"
            let boosterY = CGFloat(Int.random(in: 300...1000))
            let booster = SKSpriteNode(imageNamed: randomBooster)
            booster.size = CGSize(width: 140, height: 60)
            booster.position = CGPoint(x: size.width, y: boosterY)
            booster.physicsBody = SKPhysicsBody(rectangleOf: booster.size)
            booster.physicsBody?.affectedByGravity = false
            booster.physicsBody?.isDynamic = true
            booster.physicsBody?.categoryBitMask = 4
            booster.physicsBody?.collisionBitMask = 1
            booster.physicsBody?.contactTestBitMask = 1
            booster.name = randomBooster
            addChild(booster)
            
            let moveAction = SKAction.move(to: CGPoint(x: 0, y: boosterY), duration: 10)
            booster.run(moveAction) {
                booster.removeFromParent()
            }
        }
    }
    
    private func makeBackground() {
        background = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "biome") ?? "biome_1")
        background.position = CGPoint(x: 0, y: size.height / 2)
        background.size = CGSize(width: 3772, height: size.height)
        background.name = "biome"
        addChild(background)
        
        addBackgroundMusic(to: background, file: "music")
    }
    
    private func makeFuelBack() {
        let fuelBack = SKSpriteNode(imageNamed: "fuel_back")
        fuelBack.position = CGPoint(x: 70, y: size.height / 2)
        fuelBack.size = CGSize(width: 55, height: 550)
        fuelBack.zPosition = 3
        addChild(fuelBack)
        
        fuelBackIndicator = SKSpriteNode(imageNamed: "fuel_back_indicator")
        fuelBackIndicator.position = CGPoint(x: 75, y: size.height / 2)
        fuelBackIndicator.size = CGSize(width: fuelBack.size.width - 15, height: fuelBack.size.height - 220)
        fuelBackIndicator.zPosition = 2
        addChild(fuelBackIndicator)
    }
    
    private func makePlane() {
        plane = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "plane") ?? "plane_1")
        plane.size = CGSize(width: 180, height: 90)
        plane.position = CGPoint(x: 240, y: size.height / 2)
        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        plane.physicsBody?.affectedByGravity = false
        plane.physicsBody?.isDynamic = false
        plane.physicsBody?.categoryBitMask = 1
        plane.physicsBody?.collisionBitMask = 2 | 3 | 4
        plane.physicsBody?.contactTestBitMask = 2 | 3 | 4
        plane.name = "plane"
        addChild(plane)
    }
    
    private func addUiInterface() {
        pauseBtn = SKSpriteNode(imageNamed: "pause_btn")
        pauseBtn.position = CGPoint(x: 75, y: size.height - 100)
        pauseBtn.size = CGSize(width: 80, height: 80)
        pauseBtn.zPosition = 5
        addChild(pauseBtn)
        
        let trasse = SKSpriteNode(imageNamed: "trasse")
        trasse.position = CGPoint(x: size.width / 2, y: size.height - 120)
        trasse.size = CGSize(width: 450, height: 80)
        trasse.zPosition = 3
        addChild(trasse)
        
        trasseIndicator = SKSpriteNode(imageNamed: "trasse_indicator")
        trasseIndicator.size = CGSize(width: 425, height: 20)
        trasseIndicator.position = CGPoint(x: size.width / 2 - 5, y: size.height - 140)
        trasseIndicator.zPosition = 4
        addChild(trasseIndicator)
        
        boosterFirstField = BoosterFieldNode(color: .clear, size: CGSize(width: 150, height: 150))
        boosterFirstField.position = CGPoint(x: size.width / 2 - 170, y: 80)
        boosterFirstField.boosterClick = { boosterName in 
            self.useBooster(boosterName)
            self.boosterFirstField.useBooster()
        }
        addChild(boosterFirstField)
        boosterSecondField = BoosterFieldNode(color: .clear, size: CGSize(width: 150, height: 150))
        boosterSecondField.position = CGPoint(x: size.width / 2, y: 80)
        boosterSecondField.boosterClick = { boosterName in 
            self.useBooster(boosterName)
            self.boosterSecondField.useBooster()
        }
        addChild(boosterSecondField)
        boosterThirdField = BoosterFieldNode(color: .clear, size: CGSize(width: 150, height: 150))
        boosterThirdField.position = CGPoint(x: size.width / 2 + 170, y: 80)
        boosterThirdField.boosterClick = { boosterName in 
            self.useBooster(boosterName)
            self.boosterThirdField.useBooster()
        }
        addChild(boosterThirdField)
        
        pauseNode = GamePauseNode(color: .clear, size: size)
        pauseNode.zPosition = 10
        pauseNode.continuePlayClicked = {
            self.isPaused = false
            self.pauseNode.removeFromParent()
        }
        pauseNode.homeBtnClicked = {
            NotificationCenter.default.post(name: Notification.Name("TO_HOME"), object: nil)
        }
        pauseNode.restarBtnClicked = {
            let newScene = PlaneGameScene()
            newScene.size = CGSize(width: 750, height: 1335)
            self.view?.presentScene(newScene)
        }
        pauseNode.soundBtnClicked = { isSoundOn in
            self.musicOn = isSoundOn
            if !self.musicOn {
                self.background.removeAllChildren()
            } else {
                self.addBackgroundMusic(to: self.background, file: "music")
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2 {
            if !boosterShield {
                addExplosion(node: bodyA.node!)
                bodyA.node!.removeFromParent()
                bodyB.node!.removeFromParent()
                loseGame()
                addSound(file: "loss_sound")
            }
        } else if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 3 {
            catchesStars += 1
            bodyB.node?.removeFromParent()
        } else if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 4 {
            let boosterName = bodyB.node!.name
            addBooster(boosterName ?? "")
            bodyB.node!.removeFromParent()
        }
    }
    
    private func addExplosion(node: SKNode) {
        if let fileParticles = SKEmitterNode(fileNamed: "Explosion") {
            fileParticles.position = node.position
            fileParticles.zPosition = 12
            fileParticles.setScale(2)
            addChild(fileParticles)
        }
    }
    
    private func useBooster(_ boosterName: String) {
        switch (boosterName) {
        case "speed":
            isBoosterSpeedUp = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isBoosterSpeedUp = false
            }
        case "fuel_up":
            addedBoosterFuel = true
            fuelBackIndicator.size.height += 0.5
            trasseIndicator.size.width += 0.5
            trasseIndicator.position.x += 0.25
        default:
            boosterShield = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.boosterShield = false
            }
        }
    }
    
    private func addBooster(_ boosterName: String) {
        if !boosterName.isEmpty {
            let boosterField = getEmptyBoosterField()
            if let boosterField = boosterField {
                boosterField.addBooster(boosterName: boosterName)
            }
        }
    }
    
    private func getEmptyBoosterField() -> BoosterFieldNode? {
        if boosterFirstField.booster != nil && boosterSecondField.booster != nil && boosterThirdField.booster == nil {
            return boosterThirdField
        } else if boosterFirstField.booster != nil && boosterSecondField.booster == nil && boosterThirdField.booster != nil {
            return boosterSecondField
        } else if boosterFirstField.booster == nil && boosterSecondField.booster != nil && boosterThirdField.booster != nil {
            return boosterFirstField
        } else if boosterFirstField.booster == nil && boosterSecondField.booster == nil && boosterThirdField.booster == nil {
            return boosterFirstField
        } else if boosterFirstField.booster != nil && boosterSecondField.booster == nil && boosterThirdField.booster == nil {
            return boosterSecondField
        }
        return nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        if background != nil {
            if isBoosterSpeedUp {
                background.position.x -= cameraSpeed * 2
            } else {
                background.position.x -= cameraSpeed
            }
         
            if background.position.x <= -(background.size.width - size.width) {
                background.position.x = size.width + background.size.width
            }
        }
        
        if plane.position.y <= 0 {
            loseGame()
        }
        
        plane.position.y -= 0.5
        fuelBackIndicator.size.height -= 0.05
        trasseIndicator.size.width -= 0.05
        trasseIndicator.position.x -= 0.025
        
        if trasseIndicator.size.width <= 0 {
            winGame()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let object = nodes(at: location)
        
        guard !object.contains(pauseBtn) else {
            showPause()
            return
        }
        
        guard !object.contains(background) else {
            plane.position.y += 25
            return
        }
    }
    
    private func showPause() {
        isPaused = true
        addChild(pauseNode)
    }
    
    private func loseGame() {
        self.background.removeAllChildren()
        NotificationCenter.default.post(name: Notification.Name("LOSE_GAME"), object: nil, userInfo: ["catchesStars": catchesStars])
    }
    
    private func winGame() {
        self.background.removeAllChildren()
        NotificationCenter.default.post(name: Notification.Name("WIN_GAME"), object: nil, userInfo:  ["catchesStars": catchesStars])
    }
    
    private func addBackgroundMusic(to background: SKNode, file: String) {
        if musicOn {
            let music = SKAudioNode(fileNamed: file)
            background.addChild(music)
        }
    }
    
    private func addSound(file: String) {
        if musicOn {
            let soundAction = SKAction.playSoundFileNamed(file, waitForCompletion: false)
            run(soundAction)
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: PlaneGameScene())
            .ignoresSafeArea()
    }
}
