//
//  Modal.swift
//  TRssReader
//
//  Created by Ty Hopp on 21/4/23.
//

import Foundation

struct Modal {
    enum Mode {
        case add
        case edit
    }
    
    var isOpen: Bool
    var mode: Mode
    var name: String?
    var url: String?
}
