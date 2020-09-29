//
//  HomeView.swift
//  FiveETab
//
//  Created by Brad Scott on 3/16/20.
//  Copyright © 2020 Brad Scott. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowing = false
    
    var body: some View {
          VStack {
                    Button(action: {
                        self.isShowing.toggle()
                    }) {
                        if self.isShowing {
                        Text("Back")
                        } else {
                            HStack {
                                Image("druid")
                                   // .resizable()
                                  //  .aspectRatio(contentMode: .fit)
                                  //  .frame(width: 200, height: 350)
                            Text("Heliax")
                        }
                        }
                    }
                    if isShowing {
                        CharView()
                    }
                }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
