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
    
    let buttonTypeIndex = [
        ButtonType.edit: Label("Edit", systemImage: "pencil.circle"),
        ButtonType.delete: Label("Delete", systemImage: "trash")
    ]
    
    var buttonType: ButtonType
    var action: (() -> Void)
    
    var body: some View {
        Button(action: action, label: {
            buttonTypeIndex[buttonType]
        })
    }
}

struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonView(buttonType: .edit, action: {
            print("Edit")
        })
        .previewDisplayName("ActionButtonView - Edit")
        
        ActionButtonView(buttonType: .delete, action: {
            print("Delete")
        })
        .previewDisplayName("ActionButtonView - Delete")
    }
}
