//
//  ValidationMessageView.swift
//  TRssReader
//
//  Created by Ty Hopp on 25/4/23.
//

import SwiftUI

struct ValidationMessageView: View {
    var message: String?
    
    var body: some View {
        if let message = message {
            Text(message)
                .foregroundColor(.red)
        } else {
            EmptyView()
        }
    }
}

struct ValidationMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ValidationMessageView(message: "URL must be unique")
    }
}
