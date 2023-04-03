//
//  ContentView.swift
//  TRssReader
//
//  Created by Ty Hopp on 29/3/23.
//

import SwiftUI

struct DetailView: View {
    var selectedFeed: Feed
    
    var body: some View {
        Text(selectedFeed.url)
    }
}

let feeds: [Feed] = [
    Feed(name: "A", url: "https://a.com", createdAt: "0"),
    Feed(name: "B", url: "https://b.com", createdAt: "0"),
    Feed(name: "C", url: "https://c.com", createdAt: "0")
]

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            List(feeds, id: \.url) { feed in
                NavigationLink(feed.name, destination: DetailView(selectedFeed: feed))
            }
        } detail: {
            Text("Please select a feed")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
