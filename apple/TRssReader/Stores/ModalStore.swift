//
//  ModalStore.swift
//  TRssReader
//
//  Created by Ty Hopp on 21/4/23.
//

import Foundation

@MainActor
final class ModalStore: ObservableObject {
    enum Mode {
        case add
        case edit
    }
    
    @Published var isOpen: Bool = false
    @Published var mode: Mode = .add
    @Published var name: String = ""
    @Published var url: String = ""
    
    func open(mode: Mode = .add, name: String = "", url: String = "") {
        self.isOpen = true
        self.mode = mode
        self.name = name
        self.url = url
    }
    
    func close() {
        self.isOpen = false
        self.mode = .add
        self.name = ""
        self.url = ""
    }
}
