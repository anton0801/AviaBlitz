import SwiftUI
import AVFoundation

struct BonusGameView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @State private var scrollToIndex: Int? = nil
    @State private var winItem: Int? = nil
    
    @State var showWinPoints = false
    
    var gainedPoints: Int
    @State var gainedPointsS: Int = 0
    
    @EnvironmentObject var playerData: PlayerData
    
    @State var bonusItemsRandom = [Int]()
    @State var isAnimatingSpin = false
    
    let bonusProbabilities = [1: 98, 2: 95, 3: 90]
    let xRates = [1: 2, 2: 50, 3: 100]

    var body: some View {
        if showWinPoints {
            VStack {
                Image("bonus_title")
                    .resizable()
                    .frame(width: 240, height: 80)
                
                Spacer()
                
                Text("+\(gainedPointsS)")
                    .font(.custom("Acme-Regular", size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .background(
                        Image("score_bg")
                            .resizable()
                            .frame(width: 170, height: 60)
                    )
                    .animation(.easeInOut(duration: 1.0))
                    .background(
                        Image("bg")
                            .resizable()
                            .frame(width: 360, height: 320)
                    )
                
                Spacer()
                
                Button {
                    presMode.wrappedValue.dismiss()
                    UserDefaults.standard.set(Date(), forKey: "last_used_bonus_time")
                } label: {
                    Image("take_btn")
                        .resizable()
                        .frame(width: 150, height: 150)
                }
                
                Spacer()
            }
            .background(
                Image("shop_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .animation(.easeInOut(duration: 1.0))
        } else {
            VStack {
                Image("bonus_title")
                    .resizable()
                    .frame(width: 240, height: 80)
                
                Spacer().frame(height: 40)
                
                Text("+\(gainedPointsS)")
                    .font(.custom("Acme-Regular", size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .background(
                        Image("score_bg")
                            .resizable()
                            .frame(width: 170, height: 60)
                    )
                
                Spacer()
                
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(0..<bonusItemsRandom.count, id: \.self) { index in
                                Spacer().frame(height: 10)
                                BonusMachineElement(bonus: bonusItemsRandom[index])
                                    .id(index)
                                Spacer().frame(height: 20)
                            }
                        }
                        .onChange(of: scrollToIndex) { index in
                            withAnimation(.easeInOut(duration: 5).delay(0.1)) {
                                scrollView.scrollTo(index, anchor: .top)
                            }
                        }
                    }
                }
                .frame(width: 360, height: 320)
                .clipped()
                .background(
                    Image("bg")
                        .resizable()
                        .frame(width: 360, height: 320)
                )
                
                Spacer()
                
                Button {
                    startSlotMachine()
                } label: {
                    Image("play_btn")
                        .resizable()
                        .frame(width: 150, height: 150)
                }
                
                Spacer()
            }
            .background(
                Image("shop_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .onAppear {
                gainedPointsS = gainedPoints
                bonusItemsRandom.append(2)
                for i in 1...250 {
                    let prevItem = bonusItemsRandom[i - 1]
                    var item = 1
                    if prevItem == 3 {
                        item = 1
                    } else if prevItem == 1 {
                        item = 2
                    } else {
                        item = 3
                    }
                    bonusItemsRandom.append(item)
                }
                playBackMusic()
            }
            .onDisappear {
                backMusicPlayer?.stop()
                backMusicPlayer = nil
                winBonusPlayer?.stop()
                winBonusPlayer = nil
            }
            .animation(.easeInOut(duration: 1.0))
        }
    }
    
    @State var backMusicPlayer: AVAudioPlayer?
    @State var winBonusPlayer: AVAudioPlayer?
    
    func playBackMusic() {
        if let path = Bundle.main.path(forResource: "bonus_menu_music", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                backMusicPlayer = try AVAudioPlayer(contentsOf: url)
                backMusicPlayer?.play()
            } catch {
            }
        }
    }
    
    func winMusic() {
        if let path = Bundle.main.path(forResource: "bonus_menu_sound", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                winBonusPlayer = try AVAudioPlayer(contentsOf: url)
                winBonusPlayer?.play()
            } catch {
            }
        }
    }
    
    func startSlotMachine() {
        scrollToIndex = Int.random(in: 200...bonusItemsRandom.count - 1)
        winItem = scrollToIndex!
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            stopSlotMachine()
        }
    }
    
    private func stopSlotMachine() {
        let bonusItem = bonusItemsRandom[winItem!]
        gainedPointsS *= bonusItem
        withAnimation {
            showWinPoints = true
        }
        winMusic()
        playerData.setPoints(points: playerData.points + gainedPointsS)
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            presMode.wrappedValue.dismiss()
        }
    }
    
    func generateRandomBonus() -> Int {
        let randomNumber = Int.random(in: 1...100)
        
        if randomNumber <= 85 {
            return 3
        } else if randomNumber >= 86 {
            return 2
        } else if randomNumber >= 99 {
            return 1
        }
        
        return 3
    }
    
}

struct BonusMachineElement: View {
    let bonus: Int?
    
    var body: some View {
        Image("bonus_item_\(bonus ?? 2)")
            .resizable()
            .frame(width: 180, height: 80)
    }
}

#Preview {
    BonusGameView(gainedPoints: 150)
        .environmentObject(PlayerData())
}
