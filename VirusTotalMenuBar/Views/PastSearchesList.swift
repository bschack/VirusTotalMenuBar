//
//  PastSearchesList.swift
//  VirusTotalMenuBar
//
//  Created by Ben Schack on 2/11/25.
//


import SwiftUI

struct PastSearchesList: View {
    var pastSearches: [URLScanForDisplay] = URLScanHistory.loadLastURLs()
    
    @State private var hoveredUrl: URLScanForDisplay? = nil
    
    var body: some View {
        VStack {
            ForEach(pastSearches) { search in
                HStack {
                    Text(shortenURL(search.url)) // Shorten the URL for display
                        .foregroundColor(self.getURLTextColor(status: search.status)) // Color based on status
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                        .onHover { hovering in
                            if hovering {
                                hoveredUrl = search // Show the details when hovered
                            } else {
                                hoveredUrl = nil // Hide the details when not hovered
                            }
                        }
                    
                    Spacer()
                }
                .background(self.hoveredUrl == search ? Color.blue.opacity(0.1) : Color.clear)
                .padding(.bottom, 5)
            }
            
            // Add the tooltip when hovered URL is present
            if let hoveredUrl = hoveredUrl {
                HoveredDetailsPopup(search: hoveredUrl)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: hoveredUrl)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: 200)
    }
    
    // Shorten the URL for display (for example, show only the domain or the first part of the URL)
    private func shortenURL(_ url: String) -> String {
        print(pastSearches)
        let components = url.split(separator: "/")
        return components.first.map { String($0) } ?? url
    }

    // Get the appropriate color for the URL text
    private func getURLTextColor(status: String) -> Color {
        switch status {
        case "malicious":
            return .red
        case "suspicious":
            return .yellow
        default:
            return .blue
        }
    }
}

struct HoveredDetailsPopup: View {
    var search: URLScanForDisplay
    
    var body: some View {
        VStack {
            Text("Malicious: \(search.malicious), Suspicious: \(search.suspicious)")
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(8)
                .padding(5)
            Spacer()
        }
        .frame(width: 200, height: 60)
        .position(x: 200, y: 20)
    }
}

