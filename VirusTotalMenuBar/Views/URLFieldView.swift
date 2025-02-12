//
//  URLFieldView.swift
//  VirusTotalMenuBar
//
//  Created by Ben Schack on 2/11/25.
//


import SwiftUI

struct URLFieldView: View {
    var placeholder: LocalizedStringKey
    @Binding var url: String
    var onSubmit: () -> Void  // Callback when user submits

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .fill(Color.secondary)
                .opacity(0.1)
                .frame(height: 23)

            HStack {
                Image(systemName: "magnifyingglass")
                    .frame(width: 11, height: 11)
                    .padding(.leading, 5)
                    .opacity(0.8)

                TextField(placeholder, text: $url)
                    .disableAutocorrection(true)
                    .lineLimit(1)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        onSubmit()  // Trigger scan when Enter is pressed
                    }

                if !url.isEmpty {
                    Button {
                        url = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .frame(width: 11, height: 11)
                            .padding(.trailing, 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(url.isEmpty ? 0 : 0.9)
                }
            }
        }
    }
}

#Preview {
    URLFieldView(placeholder: "Enter URL", url: .constant("https://example.com")) {
        print("URL Submitted")
    }
    .frame(width: 300)
}
