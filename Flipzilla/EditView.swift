//
//  EditView.swift
//  Flipzilla
//
//  Created by Elie Cohen on 11/18/22.
//

import SwiftUI

struct EditView: View {
    @State private var prompt = ""
    @State private var answer = ""

    var body: some View {
        NavigationStack {
            VStack {
                // Edit area
                VStack {
                    TextField("Prompt", text: $prompt)
                    TextField("Answer", text: $answer)
                    Button {
                        insertCard()
                    } label: {
                        Text("Add to stack")
                    }
                }
                // Existing list
                VStack {
                    
                }
            }
        }
    }
    
    func insertCard() {
        
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
