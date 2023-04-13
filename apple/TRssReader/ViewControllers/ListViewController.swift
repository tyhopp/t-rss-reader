//
//  ListViewController.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct ListViewController: View {
    // TODO: Fetch feeds
    let feeds: [Feed] = [
        Feed(name: "A", url: "https://a.com", createdAt: 0),
        Feed(name: "B", url: "https://b.com", createdAt: 0),
        Feed(name: "C", url: "https://c.com", createdAt: 0)
    ]
    
    var body: some View {
        List(feeds, id: \.url) { feed in
            NavigationLink(feed.name, destination: DetailsViewController(selectedFeed: feed))
        }
    }
}

struct ListViewController_Previews: PreviewProvider {
    static var previews: some View {
        ListViewController()
    }
}
