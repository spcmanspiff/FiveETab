//
//  MagicItemsView.swift
//  FiveETab
//
//  Created by Brad Scott on 3/16/20.
//  Copyright © 2020 Brad Scott. All rights reserved.
//

import SwiftUI

// MARK: - RaceDetail
struct RaceDetail: Codable {
    let name, slug, desc, asiDesc: String?
    let asi: [Asi]?
    let age, alignment, size: String?
    let speed: Speed?
    let speedDesc, languages, vision, traits: String?
    let subraces: [Subrace]?
    let documentSlug, documentTitle: String?
    let documentLicenseURL: String?

    enum CodingKeys: String, CodingKey {
        case name, slug, desc
        case asiDesc = "asi_desc"
        case asi, age, alignment, size, speed
        case speedDesc = "speed_desc"
        case languages, vision, traits, subraces
        case documentSlug = "document__slug"
        case documentTitle = "document__title"
        case documentLicenseURL = "document__license_url"
    }
}

// MARK: - Asi
struct Asi: Codable {
    let attributes: [String]?
    let value: Int?
}


// MARK: - Subrace
struct Subrace: Codable {
    let name, slug, desc: String?
    let asi: [Asi]?
    let traits, asiDesc, documentSlug, documentTitle: String?

    enum CodingKeys: String, CodingKey {
        case name, slug, desc, asi, traits
        case asiDesc = "asi_desc"
        case documentSlug = "document__slug"
        case documentTitle = "document__title"
    }
}
class TappedRace : ObservableObject {
    @Published var tappedRace: String = ""
}



struct RacesView: View {
    @State private var results = [Result]()
    @State private var searchText: String = ""
    @State private var raceName = ""
    @ObservedObject var tappedRace = TappedRace()
    
    
    @State private var raceDetails = RaceDetail(name: "", slug: "", desc: "", asiDesc: "", asi: [], age: "", alignment: "", size: "", speed: Speed(walk: 0), speedDesc: "", languages: "", vision: "", traits: "", subraces: [], documentSlug: "", documentTitle: "", documentLicenseURL: "")
    
 //  var updateName: RaceDetail
    
    var body: some View {
      //  HStack {
        NavigationView {
           
            VStack(alignment: .leading) {
                Text("Races")
                    .font(.largeTitle)
                    .padding(.top, 10).padding(.leading,10)
                SearchBar(text: $searchText, placeholder: "Search")
             
                      List {
                             ForEach(self.results.filter {
                                 self.searchText.isEmpty ? true : $0.name.lowercased().contains("\(self.searchText.lowercased())")
                             }, id: \.name) { races in
                                NavigationLink(destination: Text("\(self.raceName)")) {
                                 HStack {
//                                     Image("\(races.name.lowercased())")
//                                         .resizable()
//                                         .frame(width: 25, height: 25)
//                                         .aspectRatio(contentMode: .fit)
//                                         .cornerRadius(5)
                                     Text("\(races.name)")
                                          .font(.headline).fontWeight(.light)
                                         .onTapGesture {
                                             self.tappedRace.tappedRace = races.index
                                             self.raceName = races.index
                                             print("Spell Tapped: \(self.tappedRace.tappedRace)")
                                             self.loadDataList(raceName: self.raceName)
                                     }
                                 }
                             }
                         }
                }.listStyle(GroupedListStyle())
            }.onAppear(perform: loadData)
        }
    }
    func loadData() {
        guard let urlTop = URL(string: "http://dnd5eapi.co/api/races/") else {
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
    func loadDataList(raceName: String) {
        guard let urlSpell = URL(string: "https://api-beta.open5e.com/races/\(raceName)") else {
            print("invalid")
            return
        }
        
        let request = URLRequest(url: urlSpell)
        print("Api endpoint \(request)")
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                do {
                    let jsonResponse = try JSONDecoder().decode(RaceDetail.self, from: data)
                    DispatchQueue.main.async {
                        self.raceDetails = jsonResponse
                        self.tappedRace.tappedRace = jsonResponse.name!
                        print(jsonResponse)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
        }.resume()
    }
}

