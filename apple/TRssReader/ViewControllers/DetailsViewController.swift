//
//  DetailsViewController.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct DetailsViewController: View {
    var selectedFeed: Feed
    
    // TODO: Fetch entries of selected feed
    
    var body: some View {
        Text(selectedFeed.url)
    }
}

struct DetailsViewController_Previews: PreviewProvider {
    static let feed: Feed = Feed(name: "A", url: "https://a.com", createdAt: 0)
    
    static var previews: some View {
        DetailsViewController(selectedFeed: feed)
    }
}
