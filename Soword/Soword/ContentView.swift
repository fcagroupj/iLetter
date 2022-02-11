//
//  ContentView.swift
//  Soword
//
//  Created by Zijian Wang on 1/28/22.
//

import SwiftUI

struct ContentView: View {
    @State var grid_N = 5
    var body: some View {
        NavigationView {
            TabView{
                gameView
                    .tabItem{
                        Image(systemName: "square.grid.2x2")
                        Text("iLetter")
                    }
                settingView
                    .tabItem{
                        Image(systemName: "gear")
                        Text("Setting")
                    }
            }
        }
        .navigationViewStyle(.stack)
        .onAppear(perform: load)
    }
    func load(){
        grid_N = UserDefaults.standard.integer(forKey: "g_wordle_n")
        if(grid_N > 5 || grid_N < 3){
            grid_N = 3
            UserDefaults.standard.set(grid_N, forKey: "g_wordle_n")
        }
        //
        let w_seed = Int.random(in: 0..<10000)
        UserDefaults.standard.set(w_seed, forKey: "g_wordle_seed")
    }
    var gameView: some View {
        VStack{
            // AppIcon
            Image("AppIcon_50")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            WordleView(grid_N: grid_N)
        }
    }
    var settingView: some View {
        VStack{
            // AppIcon
            
            MeHome()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
