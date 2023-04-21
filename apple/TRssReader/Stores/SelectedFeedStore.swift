//
//  SelectedFeedStore.swift
//  TRssReader
//
//  Created by Ty Hopp on 20/4/23.
//

import Foundation

protocol SelectedFeedStorable {
    var feedUrl: String? { get set }
}

final class SelectedFeedStore: SelectedFeedStorable, ObservableObject {
    @Published var feedUrl: String?
}
