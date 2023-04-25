//
//  ModalStore.swift
//  TRssReader
//
//  Created by Ty Hopp on 21/4/23.
//

import Foundation

final class ModalStore: ObservableObject {
    @Published var modal: Modal = Modal(isOpen: false, mode: .add)
    
    func open(mode: Modal.Mode = .add, name: String? = nil, url: String? = nil) {
        modal = Modal(isOpen: true, mode: mode, name: name, url: url)
    }
    
    func close() {
        modal = Modal(isOpen: false, mode: .add, name: nil, url: nil)
    }
}
