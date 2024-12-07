//
//  ResultMessageView.swift
//  TRssReader
//
//  Created by Ty Hopp on 14/4/23.
//

import SwiftUI

enum ResultMessage: String {
    case success = "Request successful"
    case failure = "Request failed"
}

struct ResultMessageView<E: Error>: View {
    @Binding var result: Result<Bool, E>?
    
    var body: some View {
        switch result {
        case .success:
            Label(ResultMessage.success.rawValue, systemImage: "checkmark.circle.fill")
                .foregroundColor(.green)
        case .failure:
            Label(ResultMessage.failure.rawValue, systemImage: "xmark.circle.fill")
                .foregroundColor(.red)
        case .none:
            EmptyView()
        }
    }
}

#Preview("Success") {
    ResultMessageView<Error>(result: .constant(.success(true)))
}

#Preview("Failure") {
    ResultMessageView<Error>(result: .constant(.failure(PreviewError.unknown)))
}

#Preview("Nil") {
    ResultMessageView<Error>(result: .constant(nil))
}
