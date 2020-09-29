//
//  SpellSearch.swift
//  FiveETab
//
//  Created by Brad Scott on 3/16/20.
//  Copyright © 2020 Brad Scott. All rights reserved.
//

import SwiftUI
import Combine




struct SpellSearch: View {
    @State private var results = [Result]()
    @State private var searchText: String = ""
    
    
    let spells =  ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search")
                List {
                    ForEach(self.results.filter {
                        self.searchText.isEmpty ? true : $0.name.contains("\(self.searchText)")
                        }, id: \.name) { spells in
                            Text("\(spells.name)")
                        
                    }
                }.onAppear(perform: loadData)
                .navigationBarTitle("Spells")
            }
        }
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
}



struct SpellSearch_Previews: PreviewProvider {
    static var previews: some View {
        SpellSearch()
    }
}
