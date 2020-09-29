//
//  TestView.swift
//  FiveETab
//
//  Created by Brad Scott on 3/12/20.
//  Copyright © 2020 Brad Scott. All rights reserved.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            VStack {
                Text("Im here!")
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
