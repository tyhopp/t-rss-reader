//
//  FeedsModelController.swift
//  TRssReader
//
//  Created by Ty Hopp on 17/4/23.
//

import Foundation

final class FeedsModelController: ObservableObject {
    static let shared = FeedsModelController()
    
    @Published var feeds: [Feed]?
    
    private init() {}
}
