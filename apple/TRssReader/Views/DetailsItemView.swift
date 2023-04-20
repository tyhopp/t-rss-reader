//
//  DetailsItemView.swift
//  TRssReader
//
//  Created by Ty Hopp on 19/4/23.
//

import SwiftUI

struct DetailsItemView: View {
    let entry: Entry
    
    var body: some View {
        Link(destination: URL(string: entry.url)!) {
            VStack(alignment: .leading) {
                Text(entry.title)
                    .font(.headline)
                    .padding([.bottom], 1)
                
                // TODO: Format date
                Text(entry.published)
                    .font(.subheadline)
                    .opacity(0.75)
            }
        }
        .foregroundColor(.primary)
        .padding(4)
    }
}

struct DetailsItemView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsItemView(entry: Entry(url: "https://a.com", title: "An entry", published: "2023-01-11T01:00:00.000Z", isNew: false))
    }
}
