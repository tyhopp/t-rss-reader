//
//  ListActionButtonView.swift
//  TRssReader
//
//  Created by Ty Hopp on 21/4/23.
//

import SwiftUI

struct ListActionButtonView: View {
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

struct ListActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ListActionButtonView(type: .edit, action: {})
            .previewDisplayName("ActionButtonView - Edit")
        
        ListActionButtonView(type: .delete, action: {})
            .previewDisplayName("ActionButtonView - Delete")
    }
}
