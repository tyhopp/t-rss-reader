//
//  ResultMessageView.swift
//  TRssReader
//
//  Created by Ty Hopp on 14/4/23.
//

import SwiftUI

struct ResultMessageView: View {
    @Binding var result: Result<Bool, Error>?
    
    enum ResultMessage: String {
        case success = "Request successful"
        case failure = "Request failed"
    }
    
    @ViewBuilder var body: some View {
        Group {
            switch result {
            case .success(_):
                Text(ResultMessage.success.rawValue)
            case .failure(_):
                Text(ResultMessage.failure.rawValue)
            case .none:
                EmptyView()
            }
        }.padding(4)
    }
}

struct ResultMessageView_Previews: PreviewProvider {
    static var previews: some View {
        let result: Result<Bool, Error>? = Result(catching: { return true })
        
        StatefulPreview(stateVariable: result) { binding in
            ResultMessageView(result: binding)
        }
    }
}
