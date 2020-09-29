//
//  ContentView.swift
//  FiveETab
//
//  Created by Brad Scott on 3/12/20.
//  Copyright © 2020 Brad Scott. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @State private var isShowing = false
    @EnvironmentObject var tappedSpell : TappedSpell

    
    var body: some View {
        TabView(selection: $selection){
          HomeView()
            .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "house").onTapGesture {
                            self.isShowing.toggle()
                        }
                        Text("Home")
                    }
            }
            .tag(0)
            SpellList()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "flame")
                        Text("Spells")
                    }
            }
            .tag(1)
            MonsterListView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "ant")
                        Text("Monsters")
                    }
            }
            .tag(2)
            NewClassView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "gamecontroller")
                        Text("Classes")
                    }
            }
            .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
