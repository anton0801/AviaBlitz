//
//  GarageShopView.swift
//  Avia Blitz
//
//  Created by Anton on 7/5/24.
//

import SwiftUI

struct GarageShopView: View {
    
    @Environment(\.presentationMode) var presMode
    
    @EnvironmentObject var playerData: PlayerData
    
    @State var shop: ShopData?
    
    @State var shopError = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button {
                    presMode.wrappedValue.dismiss()
                } label: {
                    Image("home_btn")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .offset(y: 25)
                
                Spacer()
                
                Image("garage_shop")
                    .resizable()
                    .frame(width: 280, height: 130)
                
                Spacer()
            }
            
            Text("\(playerData.points)")
                .font(.custom("Acme-Regular", size: 24))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .background(
                    Image("score_bg")
                        .resizable()
                        .frame(width: 170, height: 60)
                )
                .padding(.top)
            
            Spacer().frame(height: 50)
            
            VStack(alignment: .leading) {
                Image("skins_label")
                    .resizable()
                    .frame(width: 100, height: 50)
                
                let planes = shop?.planes ?? []
                HStack {
                    ForEach(planes, id: \.name) { plane in
                        ZStack {
                            Image("shop_\(plane.name)")
                                .resizable()
                                .frame(width: 120, height: 120)
                            if playerData.plane == plane.name {
                                Image("used_btn")
                                    .resizable()
                                    .frame(width: 100, height: 30)
                                    .offset(y: 50)
                            } else {
                                if shop!.buyedShopItems.contains(plane.name) {
                                    Button {
                                        playerData.setPlane(plane: plane.name)
                                    } label: {
                                        Image("use_btn")
                                            .resizable()
                                            .frame(width: 100, height: 30)
                                    }
                                    .offset(y: 50)
                                } else {
                                    Button {
                                        shopError = !shop!.tryToBuyShopItem(plane)
                                    } label: {
                                        ZStack {
                                            Image("btn_bg")
                                                .resizable()
                                                .frame(width: 100, height: 30)
                                            HStack {
                                                Text("\(plane.price)")
                                                    .font(.custom("Acme-Regular", size: 17))
                                                    .foregroundColor(Color.init(red: 255/255, green: 251/255, blue: 158/255))
                                                Image("star")
                                            }
                                        }
                                    }
                                    .offset(y: 50)
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer().frame(height: 32)
            
            VStack(alignment: .leading) {
                Image("biomes_label")
                    .resizable()
                    .frame(width: 100, height: 50)
                
                let biomes = shop?.biomes ?? []
                HStack {
                    ForEach(biomes, id: \.name) { biome in
                        ZStack {
                            Image("shop_\(biome.name)")
                                .resizable()
                                .frame(width: 120, height: 120)
                            if playerData.biome == biome.name {
                                Image("used_btn")
                                    .resizable()
                                    .frame(width: 100, height: 30)
                                    .offset(y: 50)
                            } else {
                                if shop!.buyedShopItems.contains(biome.name) {
                                    Button {
                                        playerData.setBiome(biome: biome.name)
                                    } label: {
                                        Image("use_btn")
                                            .resizable()
                                            .frame(width: 100, height: 30)
                                    }
                                    .offset(y: 50)
                                } else {
                                    Button {
                                        shopError = !shop!.tryToBuyShopItem(biome)
                                    } label: {
                                        ZStack {
                                            Image("btn_bg")
                                                .resizable()
                                                .frame(width: 100, height: 30)
                                            HStack {
                                                Text("\(biome.price)")
                                                    .font(.custom("Acme-Regular", size: 17))
                                                    .foregroundColor(Color.init(red: 255/255, green: 251/255, blue: 158/255))
                                                Image("star")
                                            }
                                        }
                                    }
                                    .offset(y: 50)
                                }
                            }
                        }
                    }
                }
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
            shop = ShopData(playerData: playerData)
        }
        .alert(isPresented: $shopError) {
            Alert(title: Text("Error!"),
                  message: Text("Not enough game points to purchase this item!"),
                  dismissButton: .cancel(Text("Ok!")))
        }
    }
}

#Preview {
    GarageShopView()
        .environmentObject(PlayerData())
}
