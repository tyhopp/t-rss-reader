//
//  SelectedFeedModelController.swift
//  TRssReader
//
//  Created by Ty Hopp on 20/4/23.
//

import Foundation

final class SelectedFeedModelController: ObservableObject {
    static let shared = SelectedFeedModelController()
    
    @Published var feedUrl: String?
    
    private init() {}
}
