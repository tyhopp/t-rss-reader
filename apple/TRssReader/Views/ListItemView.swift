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
                
                Text(feed.url)
                    .font(.subheadline)
                    .opacity(0.75)
            }
        }
        .padding([.top, .bottom], 4)
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(feed: Feed(name: "A feed", url: "https://a.com", createdAt: 0))
    }
}
