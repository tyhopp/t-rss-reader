//
//  ListDetailsViewController.swift
//  TRssReader
//
//  Created by Ty Hopp on 13/4/23.
//

import Foundation
import SwiftUI

struct ListDetailsViewController: View {
    @EnvironmentObject var tokenModelController: TokenModelController
    
    var body: some View {
        NavigationSplitView {
            ListViewController()
        } detail: {
            Text("Please select a feed")
        }
    }
}

struct ListDetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        ListDetailsViewController()
    }
}
