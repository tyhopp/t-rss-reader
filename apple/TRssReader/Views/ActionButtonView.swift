//
//  ActionButtonView.swift
//  TRssReader
//
//  Created by Ty Hopp on 21/4/23.
//

import SwiftUI

struct ActionButtonView: View {
    enum ButtonType {
        case edit
        case delete
    }
    
    let role: [ButtonType: ButtonRole?] = [
        .edit: nil,
        .delete: .destructive
    ]
    
    let label: [ButtonType: Label] = [
        .edit: Label("Edit", systemImage: "pencil.circle"),
        .delete: Label("Delete", systemImage: "trash")
    ]
    
    let tint: [ButtonType: Color] = [
        .edit: .blue,
        .delete: .red
    ]
    
    var type: ButtonType
    var action: (() -> Void)
    
    var body: some View {
        Button(
            role: role[type] as? ButtonRole,
            action: action,
            label: {
                label[type]
            }
        )
        .tint(tint[type])
    }
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonView(type: .edit, action: {})
            .previewDisplayName("ActionButtonView - Edit")
        
        ActionButtonView(type: .delete, action: {})
            .previewDisplayName("ActionButtonView - Delete")
    }
}
