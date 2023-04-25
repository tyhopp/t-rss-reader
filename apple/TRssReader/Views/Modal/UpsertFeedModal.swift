//
//  UpsertFeedModal.swift
//  TRssReader
//
//  Created by Ty Hopp on 25/4/23.
//

import SwiftUI

struct UpsertFeedModal: View {
    @EnvironmentObject var modalStore: ModalStore
    @EnvironmentObject var feedsStore: FeedsStore
    
    @State private var maySubmit: Bool = false
    @State private var loading: Bool = false
    @State private var validationMessage: String = ""
    @State private var result: Result<Bool, Error>?
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedElement: FocusElement?
    
    private enum FocusElement {
        case name
        case url
    }
    
    private var feedsService: FeedsService = FeedsService()
    
    private var titleText: String {
        get {
            modalStore.mode == .edit ? "Edit feed" : "Add feed"
        }
    }
    
    private var submitButtonText: String {
        get {
            return loading ? "Submitting..." : "Submit"
        }
    }
    
    private func validate() {
        if loading || modalStore.url.isEmpty {
            validationMessage = ""
            maySubmit = false
            return
        }
        
        if !modalStore.url.starts(with: /https:\/\//) {
            validationMessage = "URL must start with https://"
            maySubmit = false
            return
        }
        
        if modalStore.mode == .add {
            if let duplicateUrl = feedsStore.feeds?.contains(where: { feed in
                return feed.url == modalStore.url
            }) {
                if duplicateUrl {
                    validationMessage = "URL must be unique"
                    maySubmit = !duplicateUrl
                    return
                }
            }
        }
        
        validationMessage = ""
        maySubmit = true
    }
    
    private func submit() async {
        // TODO: Implement
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section {
                    TextField(text: $modalStore.name) {
                        Text("Name")
                    }
                    .focused($focusedElement, equals: .name)
                    .autocorrectionDisabled(true)
                    #if os(iOS)
                    .textInputAutocapitalization(.words)
                    #endif
                    .disabled(loading)
                    
                    TextField(text: $modalStore.url) {
                        Text("URL")
                    }
                    .focused($focusedElement, equals: .url)
                    .autocorrectionDisabled(true)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    #endif
                    .onReceive(modalStore.$url, perform: { _ in
                        validate()
                    })
                    .disabled(modalStore.mode == .edit || loading)
                } header: {
                    Text("")
                } footer: {
                    Group {
                        ValidationMessageView(message: validationMessage)
                        ResultMessageView(result: $result)
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            focusedElement = .name
        }
        .onSubmit {
            if focusedElement == .name {
                focusedElement = .url
            } else {
                focusedElement = nil
            }
        }
        #if os(macOS)
        .frame(
            idealWidth: 300,
            maxWidth: 300
        )
        .padding()
        #endif
        .navigationTitle(titleText)
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
                    .disabled(loading || !maySubmit)
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
