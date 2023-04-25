//
//  SelectedFeedStore.swift
//  TRssReader
//
//  Created by Ty Hopp on 20/4/23.
//

import Foundation

final class SelectedFeedStore: ObservableObject {
    @Published var feedUrl: String?
}
