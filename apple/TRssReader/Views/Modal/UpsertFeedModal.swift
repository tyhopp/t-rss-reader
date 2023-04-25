//
//  UpsertFeedModal.swift
//  TRssReader
//
//  Created by Ty Hopp on 25/4/23.
//

import SwiftUI

struct UpsertFeedModal: View {
    @EnvironmentObject var modalStore: ModalStore
    
    @State private var loading: Bool = false
    @State private var result: Result<Bool, Error>?
    
    @Environment(\.dismiss) private var dismiss
    
    private var feedsService: FeedsService = FeedsService()
    
    private var title: String {
        get {
            modalStore.mode == .edit ? "Edit feed" : "Add feed"
        }
    }
    
    private var submitButtonText: String {
        get {
            return loading ? "Submitting..." : "Submit"
        }
    }
    
    private func submit() async {
        // TODO: Implement
    }
    
    var body: some View {
        #if os(iOS)
        Spacer()
            .frame(height: 20)
        #endif
        
        ResultMessageView(result: $result)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top], 4)
        
        Form {
            Section {
                TextField(text: $modalStore.name) {
                    Text("Name")
                }
                .disabled(loading)
                
                TextField(text: $modalStore.url) {
                    Text("URL")
                }
                .disabled(modalStore.mode == .edit || loading)
            }
        }
        #if os(macOS)
        .frame(
            idealWidth: 300.0,
            maxWidth: 300.0
        )
        .padding()
        #endif
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(submitButtonText) {
                    Task {
                        // TOOD: Implement
                        loading = true
                        await submit()
                        loading = false
                    }
                }
                    // TODO: Validation
                    .disabled(loading)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .disabled(loading)
            }
        }
        .interactiveDismissDisabled(loading)
    }
    
    struct UpsertFeedModal_Previews: PreviewProvider {
        static var previews: some View {
            UpsertFeedModal()
                .environmentObject(ModalStore())
        }
    }
}
