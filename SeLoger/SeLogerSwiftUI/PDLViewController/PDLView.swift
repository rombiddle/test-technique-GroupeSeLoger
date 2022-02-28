//
//  PDLView.swift
//  SeLogerSwiftUI
//
//  Created by Romain Brunie on 22/02/2022.
//

import SwiftUI
import SeLoger

public struct PDLView: View {
    @ObservedObject var viewModel: PDLViewModel
    private var selection: (Int) -> PDDView
    
    public init(viewModel: PDLViewModel, selection: @escaping (Int) -> PDDView) {
        self.viewModel = viewModel
        self.selection = selection
    }
    
    public var body: some View {
        PDLListView(properties: viewModel.properties, selection: selection, reload: viewModel.reload)
    }
}
