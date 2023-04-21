//
//  ListDetailsView.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct ListDetailsView: View {
    @State var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            ListView()
                .navigationTitle("Feeds")
            #if os(macOS)
                .navigationSplitViewColumnWidth(
                    min: 250, ideal: 300)
            #endif
        } detail: {
            DetailsView()
        }
    }
}

struct ListDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailsView()
    }
}
