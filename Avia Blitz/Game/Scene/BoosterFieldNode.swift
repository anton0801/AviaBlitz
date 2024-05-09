import Foundation
import SpriteKit

class BoosterFieldNode: SKSpriteNode {
    
    private var boosterField: SKSpriteNode!
    var booster: SKSpriteNode?
    
    var currentBoosterName: String? = nil
    
    var boosterClick: ((String) -> Void)?
    
    init(color: UIColor, size: CGSize) {
        super.init(texture: nil, color: color, size: size)
        
        boosterField = SKSpriteNode(imageNamed: "booster_field")
        boosterField.size = CGSize(width: 150, height: 150)
        addChild(boosterField)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBooster(boosterName: String) {
        booster = SKSpriteNode(imageNamed: "booster_\(boosterName)")
        booster!.size = CGSize(width: 130, height: 130)
        booster!.position = CGPoint(x: 0, y: 0)
        addChild(booster!)
        currentBoosterName = boosterName
    }
    
    func useBooster() {
        booster?.removeFromParent()
        booster = nil
        currentBoosterName = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let objects = nodes(at: location)

        if let booster = booster {
            guard !objects.contains(booster) else {
                boosterClick?(currentBoosterName!)
                return
            }
        }
    }
    
}
