import SwiftUI

struct GarageView: View {
    
    @State var playerData = PlayerData()
    
    @State var showErrorUpgrade = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image("sound_on_btn")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .opacity(0)
                    
                    Spacer()
                    
                    Text("\(playerData.points)")
                        .font(.custom("Acme-Regular", size: 24))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .background(
                            Image("score_bg")
                                .resizable()
                                .frame(width: 170, height: 60)
                        )
                    
                    Spacer()
                    
                    NavigationLink(destination: GarageShopView()
                        .environmentObject(playerData)
                        .navigationBarBackButtonHidden(true)) {
                        Image("shop_btn")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                }
                .padding()
                
                Image("garage_logo")
                    .resizable()
                    .frame(width: 220, height: 130)
                
                Image("preview_plane_1")
                    .resizable()
                    .frame(width: 280, height: 280)
                
                HStack {
                    VStack {
                        VStack {
                            Image("ic_speed")
                                .resizable()
                                .frame(width: 42, height: 24)
                            
                            Text("SPEED 10 m/s")
                                .font(.custom("Acme-Regular", size: 13))
                                .foregroundColor(Color.init(red: 67/255, green: 0/255, blue: 0/255))
                                .shadow(color: Color.init(red: 255/255, green: 123/255, blue: 123/255), radius: 3)
                            
                            Button {
                                if playerData.points >= 100 {
                                    playerData.setPoints(points: playerData.points - 100)
                                } else {
                                    showErrorUpgrade = true
                                }
                            } label: {
                                VStack(spacing: 0) {
                                    Text("UPGRADE")
                                        .font(.custom("Acme-Regular", size: 13))
                                        .foregroundColor(.white)
                                    HStack {
                                        Text("100")
                                            .font(.custom("Acme-Regular", size: 13))
                                            .foregroundColor(Color.init(red: 255/255, green: 251/255, blue: 158/255))
                                        Image("star")
                                    }
                                }
                                .background(
                                    Image("btn_bg")
                                        .resizable()
                                        .frame(width: 90, height: 40)
                                )
                            }
                            .padding(.top, 1)
                            
                        }
                        .background(
                            Image("btn_bg2")
                                .resizable()
                                .frame(width: 100, height: 120)
                        )
                        
                        Spacer().frame(height: 25)
                        
                        VStack {
                            Image("ic_fuel")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("FUEL 10 kl")
                                .font(.custom("Acme-Regular", size: 13))
                                .foregroundColor(Color.init(red: 67/255, green: 0/255, blue: 0/255))
                                .shadow(color: Color.init(red: 255/255, green: 123/255, blue: 123/255), radius: 3)
                            
                            Button {
                                if playerData.points >= 500 {
                                    playerData.setPoints(points: playerData.points - 500)
                                } else {
                                    showErrorUpgrade = true
                                }
                            } label: {
                                VStack(spacing: 0) {
                                    Text("UPGRADE")
                                        .font(.custom("Acme-Regular", size: 13))
                                        .foregroundColor(.white)
                                    HStack {
                                        Text("500")
                                            .font(.custom("Acme-Regular", size: 13))
                                            .foregroundColor(Color.init(red: 255/255, green: 251/255, blue: 158/255))
                                        Image("star")
                                    }
                                }
                                .background(
                                    Image("btn_bg")
                                        .resizable()
                                        .frame(width: 90, height: 40)
                                )
                            }
                            .padding(.top, 1)
                            
                        }
                        .background(
                            Image("btn_bg2")
                                .resizable()
                                .frame(width: 100, height: 120)
                        )
                    }
                    
                    Spacer().frame(width: 12)
                    
                    NavigationLink(destination: GameView()
                        .environmentObject(playerData)
                        .navigationBarBackButtonHidden(true)) {
                            Image("play_btn")
                                .resizable()
                                .frame(width: 150, height: 150)
                        }
                    
                    Spacer().frame(width: 12)
                    
                    VStack {
                        VStack {
                            Image("ic_armor")
                                .resizable()
                                .frame(width: 42, height: 24)
                            
                            Text("ARMOR 5%")
                                .font(.custom("Acme-Regular", size: 13))
                                .foregroundColor(Color.init(red: 67/255, green: 0/255, blue: 0/255))
                                .shadow(color: Color.init(red: 255/255, green: 123/255, blue: 123/255), radius: 3)
                            
                            Button {
                                if playerData.points >= 1000 {
                                    playerData.setPoints(points: playerData.points - 1000)
                                } else {
                                    showErrorUpgrade = true
                                }
                            } label: {
                                VStack(spacing: 0) {
                                    Text("UPGRADE")
                                        .font(.custom("Acme-Regular", size: 13))
                                        .foregroundColor(.white)
                                    HStack {
                                        Text("1000")
                                            .font(.custom("Acme-Regular", size: 13))
                                            .foregroundColor(Color.init(red: 255/255, green: 251/255, blue: 158/255))
                                        Image("star")
                                    }
                                }
                                .background(
                                    Image("btn_bg")
                                        .resizable()
                                        .frame(width: 90, height: 40)
                                )
                            }
                            .padding(.top, 1)
                            
                        }
                        .background(
                            Image("btn_bg2")
                                .resizable()
                                .frame(width: 100, height: 120)
                        )
                        
                        Spacer().frame(height: 25)
                        
                        VStack {
                            Image("ic_storage")
                                .resizable()
                                .frame(width: 24, height: 24)
                            
                            Text("STORAGE 5T")
                                .font(.custom("Acme-Regular", size: 13))
                                .foregroundColor(Color.init(red: 67/255, green: 0/255, blue: 0/255))
                                .shadow(color: Color.init(red: 255/255, green: 123/255, blue: 123/255), radius: 3)
                            
                            Button {
                                if playerData.points >= 1500 {
                                    playerData.setPoints(points: playerData.points - 1500)
                                } else {
                                    showErrorUpgrade = true
                                }
                            } label: {
                                VStack(spacing: 0) {
                                    Text("UPGRADE")
                                        .font(.custom("Acme-Regular", size: 13))
                                        .foregroundColor(.white)
                                    HStack {
                                        Text("1500")
                                            .font(.custom("Acme-Regular", size: 13))
                                            .foregroundColor(Color.init(red: 255/255, green: 251/255, blue: 158/255))
                                        Image("star")
                                    }
                                }
                                .background(
                                    Image("btn_bg")
                                        .resizable()
                                        .frame(width: 90, height: 40)
                                )
                            }
                            .padding(.top, 1)
                            
                        }
                        .background(
                            Image("btn_bg2")
                                .resizable()
                                .frame(width: 100, height: 120)
                        )
                    }
                }
            }
            .background(
                Image("garage_back")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            )
            .alert(isPresented: $showErrorUpgrade) {
                Alert(title: Text("Error!"),
                message: Text("You don't have enough points to improve your airplane! Play, catch stars and play the bonus game to increase your reward"),
                      dismissButton: .cancel(Text("Ok")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    GarageView()
}
