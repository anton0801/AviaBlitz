import SwiftUI
import SpriteKit

struct GameView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var playerData: PlayerData
    
    @State var gameWin = false
    @State var gameLose = false
    @State var bonusGameShow = false
    
    @State var gainedPoints = 0
    
    var gameScene: PlaneGameScene {
        get {
            return PlaneGameScene()
        }
    }
    
    var body: some View {
        if bonusGameShow {
            BonusGameView(gainedPoints: gainedPoints)
                .environmentObject(playerData)
        } else if gameWin {
            VStack {
                Image("win_title")
                    .resizable()
                    .frame(width: 300, height: 130)
                
                Spacer().frame(height: 40)
                
                Text("+\(gainedPoints)")
                    .font(.custom("Acme-Regular", size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .background(
                        Image("score_bg")
                            .resizable()
                            .frame(width: 170, height: 60)
                    )
                
                Spacer()
                
                HStack {
                    Button {
                        let totalPoints = playerData.points + gainedPoints
                        playerData.setPoints(points: totalPoints)
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("home_btn")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    
                   
                    
                    if checkIfAvailableBonus() {
                        Button {
                            withAnimation {
                                gameWin = false
                                bonusGameShow = true
                            }
                        } label: {
                            Image("play_bonus_btn")
                                .resizable()
                                .frame(width: 140, height: 140)
                        }
                    }
                    
                    
                    Button {
                        let totalPoints = playerData.points + gainedPoints
                        playerData.setPoints(points: totalPoints)
                        //gameScene = PlaneGameScene()
                        gameWin = false
                        gameLose = false
                        gainedPoints = 0
                    } label: {
                        Image("restart_btn")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                }
            }
            .background(
                Image("win_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        } else if gameLose {
            VStack {
                Spacer()
                
                Text("+\(gainedPoints)")
                    .font(.custom("Acme-Regular", size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .background(
                        Image("score_bg")
                            .resizable()
                            .frame(width: 170, height: 60)
                    )
                
                Spacer().frame(height: 40)
                
                HStack {
                    Button {
                        let totalPoints = playerData.points + gainedPoints
                        playerData.setPoints(points: totalPoints)
                        presMode.wrappedValue.dismiss()
                    } label: {
                        Image("home_btn")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    
                    Button {
                        let totalPoints = playerData.points + gainedPoints
                        playerData.setPoints(points: totalPoints)
                        // gameScene = PlaneGameScene()
                        gameWin = false
                        gameLose = false
                        gainedPoints = 0
                    } label: {
                        Image("restart_btn")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                }
            }
            .background(
                Image("loss_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
        } else {
            VStack {
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("WIN_GAME"))) { notification in
                if let catchesStars = notification.userInfo?["catchesStars"] as? Int {
                    gainedPoints = catchesStars
                    withAnimation {
                        self.gameWin = true
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LOSE_GAME"))) { notification in
                if let catchesStars = notification.userInfo?["catchesStars"] as? Int {
                    gainedPoints = catchesStars
                    playerData.setPoints(points: playerData.points + catchesStars)
                    withAnimation {
                        self.gameLose = true
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("TO_HOME"))) { notification in
                presMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func checkIfAvailableBonus() -> Bool {
        let lastUsedDateBonus = UserDefaults.standard.object(forKey: "last_used_bonus_time") as? Date
        if let lastUsedDateBonus = lastUsedDateBonus {
            let currentDate = Date()
            let timeDifference = currentDate.timeIntervalSince(lastUsedDateBonus)
            if timeDifference >= (3 * 3600) { // 3 часа в секундах
                return true
            }
            return false
        }
        return true
    }
    
}

#Preview {
    GameView()
        .environmentObject(PlayerData())
}
