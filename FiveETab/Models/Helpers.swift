//
//  Helpers.swift
//  FiveETab
//
//  Created by Brad Scott on 3/12/20.
//  Copyright © 2020 Brad Scott. All rights reserved.
//

import SwiftUI

// MARK: - Classes
struct Classes : Codable {
    let count: Int
    let results: [Result]
}

struct ClassNames: Identifiable {
    let name: String
    let id = UUID()
    let side: String
}

struct Spells : Codable {
    let count: Int
    let results: [Result]
}
struct Monsters : Codable {
    let count: Int
    let results: [Result]
}

struct Races : Codable {
    let count: Int
    let results: [Result]
}

// MARK: - Result
struct Result : Codable, Hashable {
    
    let index, name, url: String
    let id = UUID()
    
    var iconName: String  {
        SpellDetails.CodingKeys.name.stringValue
    }

}


struct SearchBar: UIViewRepresentable{
@Binding var text: String
var placeholder: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

// MARK: - ClassDetailInfo
struct ClassDetailInfo: Codable {
    let id, index, name: String
    let hitDie: Int
    let proficiencyChoices: [ProficiencyChoice]
    let proficiencies, savingThrows: [Proficiency]
    let startingEquipment, classLevels: ClassLevels
    let subclasses: [Proficiency]
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case index, name
        case hitDie = "hit_die"
        case proficiencyChoices = "proficiency_choices"
        case proficiencies
        case savingThrows = "saving_throws"
        case startingEquipment = "starting_equipment"
        case classLevels = "class_levels"
        case subclasses, url
    }
}

// MARK: - ClassLevels
struct ClassLevels: Codable {
    let url, classLevelsClass: String
    
    enum CodingKeys: String, CodingKey {
        case url
        case classLevelsClass = "class"
    }
}

// MARK: - Proficiency
struct Proficiency: Codable {
    let name, url: String
}

// MARK: - ProficiencyChoice
struct ProficiencyChoice: Codable, Identifiable {
    let id = UUID()
    let choose: Int
    let type: String
    let from: [Proficiency]
}
