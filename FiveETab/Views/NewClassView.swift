//
//  NewClassView.swift
//  FiveETab
//
//  Created by Brad Scott on 3/16/20.
//  Copyright © 2020 Brad Scott. All rights reserved.
//

import SwiftUI
import Foundation

// MARK: - ClassDetails
struct ClassDetails: Codable {
    let name, slug, desc, hitDice: String?
    let hpAt1StLevel, hpAtHigherLevels, profArmor, profWeapons: String?
    let profTools, profSavingThrows, profSkills, equipment: String?
    let table, spellcastingAbility, subtypesName: String?
    let archetypes: [Archetype]?
    let documentSlug, documentTitle: String?
    let documentLicenseURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name, slug, desc
        case hitDice = "hit_dice"
        case hpAt1StLevel = "hp_at_1st_level"
        case hpAtHigherLevels = "hp_at_higher_levels"
        case profArmor = "prof_armor"
        case profWeapons = "prof_weapons"
        case profTools = "prof_tools"
        case profSavingThrows = "prof_saving_throws"
        case profSkills = "prof_skills"
        case equipment, table
        case spellcastingAbility = "spellcasting_ability"
        case subtypesName = "subtypes_name"
        case archetypes
        case documentSlug = "document__slug"
        case documentTitle = "document__title"
        case documentLicenseURL = "document__license_url"
    }
}


// MARK: - Archetype
struct Archetype: Codable {
    let name, slug, desc, documentSlug: String?
    let documentTitle: String?
    let documentLicenseURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name, slug, desc
        case documentSlug = "document__slug"
        case documentTitle = "document__title"
        case documentLicenseURL = "document__license_url"
    }
}

class TappedClass : ObservableObject {
    @Published var tappedClass = ""
}


struct NewClassView: View {
    @State private var results = [Result]()
    @State private var searchText: String = ""
    @ObservedObject var tappedClass = TappedClass()
    @State private var className = "bard"
    
    @State private var classDetails = ClassDetails(name: "", slug: "", desc: "", hitDice: "", hpAt1StLevel: "", hpAtHigherLevels: "", profArmor: "", profWeapons: "", profTools: "", profSavingThrows: "", profSkills: "", equipment: "", table: "", spellcastingAbility: "", subtypesName: "", archetypes: [], documentSlug: "", documentTitle: "", documentLicenseURL: "")
    
    @State var expand = false
    @State var expand1 = false
    @State var expand2 = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Classes")
                    .font(.largeTitle)
                    // .fontWeight(.heavy)
                    .padding(.leading, 10).padding(.top, 10)
                SearchBar(text: $searchText, placeholder: "Search")
                List {
                    ForEach(self.results.filter {
                        self.searchText.isEmpty ? true : $0.name.lowercased().contains("\(self.searchText.lowercased())")
                    }, id: \.name) { classes in
                        HStack {
                            Image("\(classes.name.lowercased())")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(5)
                            Text("\(classes.name)")
                                 .font(.headline).fontWeight(.light)
                                .onTapGesture {
                                    self.tappedClass.tappedClass = classes.index
                                    self.className = classes.index
                                    print("Spell Tapped: \(self.tappedClass.tappedClass)")
                                    self.loadDataList(className: self.className)
                            }
                        }
                    }
                }
            }.onAppear(perform: loadData)
                .frame(width: 300)
            VStack {
                Form {
                    Section(header: Text("Class Info")) {
                        Text("Name: \(classDetails.name!)")
                            .fontWeight(.light).font(.headline)
                        Text("Hit Die: \(classDetails.hitDice!)")
                            .font(.headline).fontWeight(.light)
                        Text("HP At 1st Level: \(classDetails.hpAt1StLevel!)")
                            .font(.headline).fontWeight(.light)
                        Text("HP At Higher Levels: \(classDetails.hpAtHigherLevels!)")
                            .font(.headline).fontWeight(.light)
                        
                    }
                    Section(header: Text("Equipment")) {
                        Text("\(classDetails.equipment!)")
                        .font(.headline).fontWeight(.light)
                    }
                    Section(header: Text("Description")) {
                        VStack(alignment: .leading, spacing: 18, content:  {
                            HStack {
                                Text("Description").fontWeight(.light).font(.headline)
                                Image(systemName: expand ? "chevron.up" :  "chevron.down")
                                    .resizable()
                                    .frame(width: 13, height: 6)
                                    .foregroundColor(.black)
                            }.onTapGesture {
                                self.expand.toggle()
                            }
                        })
                        if expand {
                            Text(classDetails.desc!)
                                .font(.headline).fontWeight(.light)
                        }
                        
                    }
                    Section(header: Text("Table")) {
                        VStack(alignment: .leading, spacing: 18, content:  {
                                                HStack {
                                                    Text("Table").fontWeight(.light).font(.headline)
                                                    Image(systemName: expand2 ? "chevron.up" :  "chevron.down")
                                                        .resizable()
                                                        .frame(width: 13, height: 6)
                                                        .foregroundColor(.black)
                                                }.onTapGesture {
                                                    self.expand2.toggle()
                                                }
                                            })
                                            if expand2 {
                                                Text(classDetails.table!)
                                                    .font(.headline).fontWeight(.light)
                                            }
                    }
                    Section(header: Text("Proficiencies")) {
                        Text("Armor: \(classDetails.profArmor ?? "")")
                            .fontWeight(.light).font(.headline)
                        Text("Weapons: \(classDetails.profWeapons ?? "")")
                            .fontWeight(.light).font(.headline)
                        Text("Tools: \(classDetails.profTools ?? "")")
                            .fontWeight(.light).font(.headline)
                        Text("Saving Throws: \(classDetails.profSavingThrows ?? "")")
                            .fontWeight(.light).font(.headline)
                        Text("Skills: \(classDetails.profSkills ?? "")")
                            .fontWeight(.light).font(.headline)
                    }
                    Section(header: Text("Archtypes")) {
                        VStack(alignment: .leading, spacing: 18, content:  {
                            HStack {
                                Text("\(classDetails.archetypes?.first?.name ?? "-")").fontWeight(.light).font(.headline)
                                Image(systemName: expand1 ? "chevron.up" :  "chevron.down")
                                    .resizable()
                                    .frame(width: 13, height: 6)
                                    .foregroundColor(.black)
                            }.onTapGesture {
                                self.expand1.toggle()
                            }
                        })
                        if expand1 {
                            Text(classDetails.archetypes?.first?.desc ?? "-")
                                .font(.headline).fontWeight(.light)
                        }
                        
                    }
                }
                
            }
        }
    }
    func loadData() {
        guard let urlTop = URL(string: "http://dnd5eapi.co/api/classes/") else {
            print("invalid")
            return
        }
        
        var request = URLRequest(url: urlTop)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        print("Api endpoint \(request)")
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                print(data)
                if let decodedResponse = try? JSONDecoder().decode(Classes.self, from: data) {
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                        
                    }
                    return
                    
                }
            }
        }.resume()
    }
    func loadDataList(className: String) {
        guard let urlSpell = URL(string: "https://api-beta.open5e.com/classes/\(className)") else {
            print("invalid")
            return
        }
        
        let request = URLRequest(url: urlSpell)
        print("Api endpoint \(request)")
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                do {
                    let jsonResponse = try JSONDecoder().decode(ClassDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.classDetails = jsonResponse
                        print(jsonResponse)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }
}


