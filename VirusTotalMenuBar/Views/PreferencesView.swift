//
//  PreferencesView.swift
//  VirusTotalMenuBar
//
//  Created by Ben Schack on 2/11/25.
//


import SwiftUI

struct PreferencesView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("VirusTotalAPIKey") private var apiKey: String = ""

    var body: some View {
        VStack {
            Text("Preferences").font(.headline).padding()

            TextField("VirusTotal API Key", text: $apiKey)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .frame(width: 300, height: 150)
        .padding()
    }
}
