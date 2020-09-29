//
//  SpellList.swift
//  FiveETab
//
//  Created by Brad Scott on 3/12/20.
//  Copyright © 2020 Brad Scott. All rights reserved.
//

import SwiftUI
import Foundation

// MARK: - SpellDetails
struct SpellDetails: Codable {
    let id, index, name: String
    let desc, higherLevel: [String]?
    let page, range: String
    let components: [String]?
    let material: String?
    let ritual: Bool?
    let duration: String?
    let concentration: Bool?
    let castingTime: String?
    let level: Int?
    let school: School?
    let classes, subclasses: [School]?
    let url: String?
    
  
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case index, name, desc
        case higherLevel = "higher_level"
        case page, range, components, material, ritual, duration, concentration
        case castingTime = "casting_time"
        case level, school, classes, subclasses, url
    }
}

//struct SchoolIcon {
//    let results = [Result]()
//    var spellDetails = SpellDetails(id: "", index: "", name: "", desc: [], higherLevel: [], page: "", range: "", components: [], material: "", ritual: true, duration: "", concentration: false, castingTime: "", level: 0, school: School(name: "", url: ""), classes: [], subclasses: [], url: "")
//
//}

// MARK: - School
struct School: Codable {
    let name, url: String
}


class TappedSpell : ObservableObject {
    @Published var tappedSpell = "acid-arrow"
}



struct SpellList: View {
    @ObservedObject var tappedSpell = TappedSpell()
    @State private var results = [Result]()
    @State private var spellName = "aid"
    @State private var  spellDetails = SpellDetails(id: "", index: "", name: "", desc: [], higherLevel: [], page: "", range: "", components: [], material: "", ritual: true, duration: "", concentration: false, castingTime: "", level: 0, school: School(name: "", url: ""), classes: [], subclasses: [], url: "")
    @State private var searchText: String = ""
    @State private var iconString: String = "wizard"
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                Text("Spells")
                    .font(.largeTitle)
                    // .fontWeight(.heavy)
                    .padding(.leading, 10).padding(.top, 10)
                SearchBar(text: $searchText, placeholder: "Search").onAppear() {
                    print("loading")
                }
                List {
                    ForEach(self.results.filter {
                        self.searchText.isEmpty ? true : $0.name.lowercased().contains("\(self.searchText.lowercased())")
                    }, id: \.name) { spells in
                        HStack {
                            Image("\(spells.iconName.lowercased())")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                            Text("\(spells.name)")
                                .font(.headline)
                                .fontWeight(.light)
                                .onTapGesture(count: 1) {
                                    self.tappedSpell.tappedSpell = spells.index
                                                                        self.spellName = spells.index
                                                                        print("Spell Tapped: \(self.tappedSpell.tappedSpell)")
                                                                        self.loadDataList(spellName: self.spellName)
                                }
                        }
                    }

                }.onAppear() {
                    loadData()
                    print("loading")
                }
            }.frame(width: 300)
            
            Spacer()
            VStack {
                Form {
                    Section(header: Text("Spell Info")) {
                        Text("Spell Name: \(spellDetails.name)")
                            .font(.headline).fontWeight(.light)
                        Text("Range: \(spellDetails.range)")
                            .font(.headline).fontWeight(.light)
                        Text("Level: \(spellDetails.level!)")
                            .font(.headline).fontWeight(.light)
                        Text("Casting Time: \(spellDetails.castingTime ?? "-")")
                            .font(.headline).fontWeight(.light)
                        Text("Duration: \(spellDetails.duration ?? "-")")
                            .font(.headline).fontWeight(.light)
                        Text("Materials: \(spellDetails.material ?? "-")")
                            .font(.headline).fontWeight(.light)
                        
                    }
                    Section {
                        HStack {
                            Text("School:")
                                .fontWeight(.light)
                            Image("\(spellDetails.school?.name.lowercased() ?? "wizard")")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                            Text("\(spellDetails.school?.name ?? "-")")
                                .fontWeight(.light)
                            
                        }
                        HStack {
                            Text("Class:")
                                .fontWeight(.light)
                            Image("\(spellDetails.classes!.first?.name.lowercased() ?? "")")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                            Text("\(spellDetails.classes?.first?.name ?? "-")")
                                .fontWeight(.light)
                        }
                        Text("Subclass: \(spellDetails.subclasses?.first?.name ?? "-")")
                            .fontWeight(.light)
                    }.font(.headline)
                    
                    Section(header: Text("Description")) {
                        Text("\(spellDetails.desc?.first ?? "-")" + " \(spellDetails.desc?.last ?? "-")")
                            .font(.headline).fontWeight(.light)
                        Text(spellDetails.higherLevel?.first ?? "")
                            .font(.headline).fontWeight(.light)
                    }
                    
                }
                
            }
            Spacer()
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        guard let urlTop = URL(string: "http://dnd5eapi.co/api/spells/") else {
            print("invalid")
            return
        }
        
        var request = URLRequest(url: urlTop)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        print("Api endpoint \(request)")
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                print(data)
                if let decodedResponse = try? JSONDecoder().decode(Spells.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                        //print(decodedResponse.results)
                        
                    }
                    return
                    
                }
            }
        }.resume()
    }
    
    func loadDataList(spellName: String) {
        guard let urlSpell = URL(string: "http://dnd5eapi.co/api/spells/\(spellName)") else {
            print("invalid")
            return
        }
        
        let request = URLRequest(url: urlSpell)
        print("Api endpoint \(request)")
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                do {
                    let jsonResponse = try JSONDecoder().decode(SpellDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.spellDetails = jsonResponse
                        self.iconString = jsonResponse.school?.name ?? ""
                        self.tappedSpell.tappedSpell = jsonResponse.index
                        print(jsonResponse)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }
    
}

