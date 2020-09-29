//
//  MonsterListView.swift
//  FiveETab
//
//  Created by Brad Scott on 3/13/20.
//  Copyright © 2020 Brad Scott. All rights reserved.
//

import SwiftUI


class TappedMonster : ObservableObject {
    @Published var tappedMonster = ""
}

struct MonsterListView: View {
    @ObservedObject var tappedMonster = TappedMonster()
    @State private var results = [Result]()
    @State private var monsterName = ""
    @State private var monsterDetails = MonsterDetails(id: "", index: "", name: "", size: "", type: "", subtype: "", alignment: "", armorClass: 0, hitPoints: 0, hitDice: "", speed: Speed(walk: 0), strength: 0, dexterity: 0, constitution: 0, intelligence: 0, wisdom: 0, charisma: 0, proficiencies: [], damageVulnerabilities: [], damageResistances: [], damageImmunities: [], conditionImmunities: [], senses: Senses(blindsight: "", passivePerception: 0), languages: "", challengeRating: 0, specialAbilities: [], actions: [], legendaryActions: [], url: "")
    
    @State private var actions = [Action]()
    @State private var legends = [LegendaryAction]()
    @State private var damage = [Damage]()
    @State private var conditionImmunity = [ConditionImmunity]()
    @State private var specialAbilities = [SpecialAbility]()
    @State private var tapped = false
    @State private var searchText: String = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Monsters")
                    .font(.largeTitle)
                    // .fontWeight(.heavy)
                    .padding(.leading, 10).padding(.top, 10)
                SearchBar(text: $searchText, placeholder: "Search")
                List {
                    ForEach(self.results.filter {
                        self.searchText.isEmpty ? true : $0.name.lowercased().contains("\(self.searchText.lowercased())")
                    }, id: \.name) { monsters in
                        Text("\(monsters.name)")
                             .font(.headline).fontWeight(.light)
                            .onTapGesture {
                                self.tappedMonster.tappedMonster = monsters.index
                                self.monsterName = monsters.index
                                print("Monster Tapped: \(self.tappedMonster.tappedMonster)")
                                self.loadDataList(monsterName: self.monsterName)
                                self.tapped.toggle()
                        }
                    }
                    .navigationBarTitle("Monsters")
                }.onAppear(perform: loadData)
            }.frame(width: 300)
            
            
            Spacer()
            VStack {
                Form {
                    Section(header: Text("Monster Info")) {
                        Text("Monster Name: \(monsterDetails.name ?? "none")")
                         .font(.headline).fontWeight(.light)
                        Text("Size: \(monsterDetails.size ?? "none")")
                         .font(.headline).fontWeight(.light)
                        HStack {
                            Text("Type:")
                             .font(.headline).fontWeight(.light)
                            Image("\(monsterDetails.type!)")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                            Text("\(monsterDetails.type ?? "none")")
                             .font(.headline).fontWeight(.light)
                        }
                        Text("Alignment: \(monsterDetails.alignment ?? "none")")
                         .font(.headline).fontWeight(.light)
                        Text("CR: \(monsterDetails.challengeRating ?? 0, specifier: "%.2f")")
                         .font(.headline).fontWeight(.light)
                    }
                    Section(header: Text("Stats")) {
                        Text("AC: \(monsterDetails.armorClass ?? 0)")
                         .font(.headline).fontWeight(.light)
                        VStack(alignment: .leading) {
                            Text("HP: \(monsterDetails.hitPoints ?? 0)")
                                 .font(.headline).fontWeight(.light)
                                .foregroundColor(Color.red)
                            Text("Hit Die: \(monsterDetails.hitDice ?? "")")
                                 .font(.headline).fontWeight(.light)
                                .font(.subheadline)
                        }
                        HStack {
                            Group {
                                Text("Str: \(monsterDetails.strength ?? 0)")
                                 .font(.headline).fontWeight(.light)
                                Divider()
                                Text("Dex: \(monsterDetails.dexterity ?? 0)")
                                 .font(.headline).fontWeight(.light)
                                Divider()
                                Text("Con: \(monsterDetails.constitution ?? 0)")
                                 .font(.headline).fontWeight(.light)
                                Divider()
                            }
                            Group {
                                Text("Int: \(monsterDetails.intelligence ?? 0)")
                                 .font(.headline).fontWeight(.light)
                                Divider()
                                Text("Cha: \(monsterDetails.charisma ?? 0)")
                                 .font(.headline).fontWeight(.light)
                                Divider()
                                Text("Wis: \(monsterDetails.wisdom ?? 0)")
                                 .font(.headline).fontWeight(.light)
                            }
                        }
                        
                    }
                    Section(header: Text("Actions")) {
                        List(actions, id: \.name) { actions in
                            VStack(alignment: .leading) {
                                Text("\(actions.name ?? "")")
                                 .font(.headline).fontWeight(.light)
                                Text("\(actions.desc ?? "")")
                                    .font(.subheadline)
                            }
                            
                        }
                    }
                    Section(header: Text("Legendary Actions")) {
                        List(legends, id: \.name) { legends in
                            VStack(alignment: .leading) {
                                Text("\(legends.name ?? "")")
                                 .font(.headline).fontWeight(.light)
                                Text("\(legends.desc ?? "")")
                                    .font(.subheadline)
                            }
                        }
                    }
                    Section(header: Text("Special Abilities")) {
                        List(specialAbilities, id: \.name) { special in
                            VStack(alignment: .leading) {
                                Text("\(special.name ?? "")")
                                 .font(.headline).fontWeight(.light)
                                Text("\(special.desc ?? "")")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                
            }
            Spacer()
        }.onAppear(perform: loadData)
        
        
    }
    func loadDataList(monsterName: String) {
      //  let baseURL = URL(string: "http://dnd5eapi.co/api/monsters/")!
        let monsterURL = URL(string: "http://dnd5eapi.co/api/monsters/\(monsterName)")!
        
        
        let baseRequest = URLRequest(url: monsterURL)
        print("Api endpoint \(baseRequest)")
        URLSession.shared.dataTask(with: baseRequest) {data, response, error in
            if let baseData = data {
                do {
                    let jsonResponse = try JSONDecoder().decode(MonsterDetails.self, from: baseData)
                    DispatchQueue.main.async {
                        self.monsterDetails = jsonResponse
                        print(jsonResponse)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
        
        let monsterRequest = URLRequest(url: monsterURL)
        URLSession.shared.dataTask(with: monsterRequest) {data, response, error in
            if let data = data {
                // print(data)
                if let decodedResponse = try? JSONDecoder().decode(Monsters.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                        //print(decodedResponse.results)
                        
                    }
                    return
                    
                }
            }
        }.resume()
        
        let monsterActionRequest = URLRequest(url: monsterURL)
        URLSession.shared.dataTask(with: monsterActionRequest) {data, response, error in
            if let data = data {
                do {
                    let jsonResponse = try JSONDecoder().decode(MonsterDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.actions = jsonResponse.actions ?? [.init(name: "", desc: "", attackBonus: 0, damage: [], dc: Dc(dcType: ConditionImmunity(name: "", url: ""), dcValue: 0, successType: ""))]
                        print(jsonResponse.actions ?? "")
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
        
        let legendRequest = URLRequest(url: monsterURL)
        URLSession.shared.dataTask(with: legendRequest) {data, response, error in
            if let data = data {
                do {
                    let jsonResponse = try JSONDecoder().decode(MonsterDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.legends = jsonResponse.legendaryActions ?? [.init(name: "", desc: "")]
                        print(jsonResponse.legendaryActions ?? "")
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
        
        let specialRequest = URLRequest(url: monsterURL)
        URLSession.shared.dataTask(with: specialRequest) {data, response, error in
            if let data = data {
                do {
                    let jsonResponse = try JSONDecoder().decode(MonsterDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.specialAbilities = jsonResponse.specialAbilities ?? [.init(name: "", desc: "", usage: Usage(type: "", times: 0))]
                        print(jsonResponse.specialAbilities ?? "")
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
        
    }
    func loadData() {
        guard let urlTop = URL(string: "http://dnd5eapi.co/api/monsters/") else {
            print("invalid")
            return
        }
        
        var request = URLRequest(url: urlTop)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        print("Api endpoint \(request)")
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                // print(data)
                if let decodedResponse = try? JSONDecoder().decode(Monsters.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                        //print(decodedResponse.results)
                        
                    }
                    return
                    
                }
            }
        }.resume()
    }
}

struct MonsterListView_Previews: PreviewProvider {
    static var previews: some View {
        MonsterListView()
    }
}
