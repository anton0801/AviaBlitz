import Foundation
import SpriteKit

class GamePauseNode: SKSpriteNode {
    
    private var homeBtn: SKSpriteNode!
    private var soundBtn: SKSpriteNode!
    private var soundOffBtn: SKSpriteNode!
    private var continuePlayBtn: SKSpriteNode!
    private var restartBtn: SKSpriteNode!
    
    var homeBtnClicked: (() -> Void)?
    var soundBtnClicked: ((Bool) -> Void)?
    var continuePlayClicked: (() -> Void)?
    var restarBtnClicked: (() -> Void)?
    
    var isSoundOn = true {
        didSet {
            if isSoundOn {
                soundOffBtn.removeFromParent()
                addChild(soundBtn)
            } else {
                soundBtn.removeFromParent()
                addChild(soundOffBtn)
            }
        }
    }
    
    init(color: UIColor, size: CGSize) {
        super.init(texture: nil, color: color, size: size)
        
        let background = SKSpriteNode(color: UIColor(red: 0.60, green: 0.11, blue: 0.11, alpha: 0.6), size: CGSize(width: size.width, height: size.height))
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(background)
        
        let pauseTitle = SKSpriteNode(imageNamed: "pause_title")
        pauseTitle.position = CGPoint(x: size.width / 2, y: size.height - 250)
        pauseTitle.size = CGSize(width: 300, height: 120)
        addChild(pauseTitle)
        
        homeBtn = SKSpriteNode(imageNamed: "home_btn")
        homeBtn.size = CGSize(width: 200, height: 180)
        homeBtn.position = CGPoint(x: size.width / 2 - 100, y: size.height / 2 + 100)
        addChild(homeBtn)
        
        soundBtn = SKSpriteNode(imageNamed: "sound_on_btn")
        soundBtn.size = CGSize(width: 200, height: 180)
        soundBtn.position = CGPoint(x: size.width / 2 + 100, y: size.height / 2 + 100)
        addChild(soundBtn)
        
        soundOffBtn = SKSpriteNode(imageNamed: "sound_off_btn")
        soundOffBtn.size = CGSize(width: 200, height: 180)
        soundOffBtn.position = CGPoint(x: size.width / 2 + 100, y: size.height / 2 + 100)
        // addChild(soundOffBtn)
        
        continuePlayBtn = SKSpriteNode(imageNamed: "continue_play_btn")
        continuePlayBtn.size = CGSize(width: 200, height: 180)
        continuePlayBtn.position = CGPoint(x: size.width / 2 - 100, y: size.height / 2 - 100)
        addChild(continuePlayBtn)
        
        restartBtn = SKSpriteNode(imageNamed: "restart_btn")
        restartBtn.size = CGSize(width: 200, height: 180)
        restartBtn.position = CGPoint(x: size.width / 2 + 100, y: size.height / 2 - 100)
        addChild(restartBtn)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let objects = nodes(at: location)

        guard !objects.contains(homeBtn) else {
            homeBtnClicked?()
            return
        }
        
        guard !objects.contains(soundBtn) else {
            soundBtnClicked?(false)
            isSoundOn = false
            return
        }
        
        guard !objects.contains(soundOffBtn) else {
            soundBtnClicked?(true)
            isSoundOn = true
            return
        }
        
        guard !objects.contains(continuePlayBtn) else {
            continuePlayClicked?()
            return
        }
        
        guard !objects.contains(restartBtn) else {
            restarBtnClicked?()
            return
        }
    }
    
}
