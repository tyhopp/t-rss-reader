//
//  ListItemView.swift
//  TRssReader
//
//  Created by Ty Hopp on 19/4/23.
//

import SwiftUI

struct ListItemView: View {
    let feed: Feed
    
    var body: some View {
        NavigationLink(value: feed.url) {
            VStack(alignment: .leading) {
                Text(feed.name)
                    .font(.headline)
                    .padding([.bottom], 1)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(feed.url)
                    .font(.subheadline)
                    .opacity(0.75)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .padding(4)
    }
}

#Preview {
    ListItemView(feed: Feed(name: "A feed", url: "https://a.com", createdAt: Date().nowInMs))
}
