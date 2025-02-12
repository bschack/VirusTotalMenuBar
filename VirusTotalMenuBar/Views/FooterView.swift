//
//  FooterView.swift
//  VirusTotalMenuBar
//
//  Created by Ben Schack on 2/11/25.
//


import SwiftUI

struct FooterView: View {
    @AppStorage("VirusTotalAPIKey") private var apiKey: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
            Divider()
            HStack {
                TextField("VirusTotal API Key", text: $apiKey)
                    .focused($isTextFieldFocused)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .blur(radius: isTextFieldFocused ? 0 : 3)
                    .animation(.easeInOut(duration: 0.1), value: isTextFieldFocused)
                Spacer()
                Button(action: { NSApplication.shared.terminate(nil) }) {
                    Text("Quit")
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}


