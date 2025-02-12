//
//  URLScanResult.swift
//  VirusTotalMenuBar
//
//  Created by Ben Schack on 2/11/25.
//


import Foundation

// Key for storing URL responses
private let lastURLsKey = "lastURLs"

// Struct to represent the scan result
struct URLScanResult: Codable {
    let url: String
    let status: String
    let link: String
    let malicious: Int
    let suspicious: Int
    let undetected: Int
    let harmless: Int
    let timeout: Int
}

struct URLScanForDisplay: Identifiable, Equatable {
    let id: UUID
    let url: String
    let status: String
    let link: String
    let malicious: Int
    let suspicious: Int
    let undetected: Int
    let harmless: Int
    let timeout: Int
}

extension URLScanForDisplay {
    init(from result: URLScanResult) {
        self.id = UUID() // Generate a unique ID
        self.url = result.url
        self.status = result.status
        self.link = result.link
        self.malicious = result.malicious
        self.suspicious = result.suspicious
        self.undetected = result.undetected
        self.harmless = result.harmless
        self.timeout = result.timeout
    }
}


class URLScanHistory {
    
    // Load the last 5 URL scan results from UserDefaults
    static func loadLastURLs() -> [URLScanForDisplay] {
        guard let data = UserDefaults.standard.data(forKey: lastURLsKey) else {
            return []
        }
        
        let decoder = JSONDecoder()
        if let results = try? decoder.decode([URLScanResult].self, from: data) {
            return results.map { URLScanForDisplay(from: $0) }
        }
        return []
    }
    
    // Load the last 5 URL scan results from UserDefaults
    static private func loadLastURLsSafe() -> [URLScanResult] {
        guard let data = UserDefaults.standard.data(forKey: lastURLsKey) else {
            return []
        }
        
        let decoder = JSONDecoder()
        if let results = try? decoder.decode([URLScanResult].self, from: data) {
            return results
        }
        return []
    }
    
    // Save the last 5 URL scan results to UserDefaults
    static func saveLastURLs(_ results: [URLScanResult]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(results) {
            UserDefaults.standard.set(data, forKey: lastURLsKey)
        }
    }
    
    // Add a new scan result and maintain only the last 5 entries
    static func addNewScanResult(_ result: URLScanResult) {
        var results = loadLastURLsSafe()
        results.insert(result, at: 0) // Add the new result to the front
        
        // Limit to the last 5
        if results.count > 5 {
            results.removeLast()
        }
        
        saveLastURLs(results)
    }
}
