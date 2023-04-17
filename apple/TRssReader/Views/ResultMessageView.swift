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
    enum ResultMessagePreviewError: Error {
        case unknown
    }
    
    static var previews: some View {
        let resultSuccess: Result<Bool, Error>? = Result(catching: { return true })
        let resultFailure: Result<Bool, Error>? = Result(catching: { throw ResultMessagePreviewError.unknown })
        
        Group {
            StatefulPreview(stateVariable: resultSuccess) { binding in
                ResultMessageView(result: binding)
            }
            .previewDisplayName("ResultMessageView - Success")
            
            StatefulPreview(stateVariable: resultFailure) { binding in
                ResultMessageView(result: binding)
            }
            .previewDisplayName("ResultMessageView - Failure")
        }
    }
}
