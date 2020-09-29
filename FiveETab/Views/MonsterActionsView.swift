//
//  MonsterActionsView.swift
//  FiveETab
//
//  Created by Brad Scott on 3/13/20.
//  Copyright © 2020 Brad Scott. All rights reserved.
//

import SwiftUI

struct MonsterActionsView: View {
    @ObservedObject var tappedMonster = TappedMonster()
    @State private var actionsList = [Action]()
    
    @State private var actions = Action(name: "", desc: "", attackBonus: 0, damage: [], dc: Dc(dcType: ConditionImmunity(name: "", url: ""), dcValue: 0, successType: ""))
    
    var body: some View {
        VStack {
            Text(actions.name ?? "none")
        }//.onAppear(perform: loadData)
    }
    
        
}

struct MonsterActionsView_Previews: PreviewProvider {
    static var previews: some View {
        MonsterActionsView()
    }
}
