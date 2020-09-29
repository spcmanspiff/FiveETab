//
//  CharView.swift
//  FiveETab
//
//  Created by Brad Scott on 4/2/20.
//  Copyright © 2020 Brad Scott. All rights reserved.
//

import SwiftUI
import WebView

struct CharView: View {
    @ObservedObject var webViewStore = WebViewStore()
    
    
    var body: some View {
        VStack {
            WebView(webView: webViewStore.webView)
                .navigationBarTitle(Text(verbatim: webViewStore.webView.title ?? ""), displayMode: .inline)
                .navigationBarItems(trailing: HStack {
                    Button(action: goBack) {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }.disabled(!webViewStore.webView.canGoBack)
                    Button(action: goForward) {
                        Image(systemName: "chevron.right")
                            .imageScale(.large)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                    }.disabled(!webViewStore.webView.canGoForward)
                })
        }.onAppear {
        self.webViewStore.webView.load(URLRequest(url: URL(string: "https://www.dndbeyond.com/profile/Bscott22/characters/25943429")!))
        }
    }
    func goBack() {
      webViewStore.webView.goBack()
    }
    
    func goForward() {
      webViewStore.webView.goForward()
    }
}

struct CharView_Previews: PreviewProvider {
    static var previews: some View {
        CharView()
    }
}
