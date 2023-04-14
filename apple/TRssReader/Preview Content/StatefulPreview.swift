//
//  StatefulPreview.swift
//  TRssReader
//
//  Created by Ty Hopp on 14/4/23.
//

import SwiftUI

struct StatefulPreview<StateVariable, Content: View>: View {
    @State var stateVariable: StateVariable
    
    var content: (Binding<StateVariable>) -> Content
    
    var body: some View {
        content($stateVariable)
    }
    
    init(stateVariable: StateVariable, content: @escaping (Binding<StateVariable>) -> Content) {
        self._stateVariable = State(wrappedValue: stateVariable)
        self.content = content
    }
}
