//
//  ContentView.swift
//  VirusTotalMenuBar
//
//  Created by Ben Schack on 2/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var url: String = ""
    

    var body: some View {
        VStack {
            URLFieldView(placeholder: "Enter URL", url: $url) {
                scanURL(url)
            }
            
            FooterView()
        }
        .frame(width: 300)
        .padding(8)
    }

    func scanURL(_ url: String) {
        @AppStorage("VirusTotalAPIKey") var apiKey: String = ""
        guard let idURL = URL(string: "https://www.virustotal.com/api/v3/urls") else {
            return
        }

        var idRequest = URLRequest(url: idURL)
        idRequest.httpMethod = "POST"
        idRequest.addValue("application/json", forHTTPHeaderField: "accept")
        idRequest.addValue(apiKey, forHTTPHeaderField: "x-apikey")
        idRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        idRequest.httpBody = "url=\(url)".data(using: .utf8)

        URLSession.shared.dataTask(with: idRequest) { data, response, error in
            guard let data = data else { return }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let dataDict = jsonResponse["data"] as? [String: Any],
                   let analysisID = dataDict["id"] as? String {
                    
                    // Call the second API to fetch the report
                    fetchAnalysisResults(analysisID)
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }
    
    func fetchAnalysisResults(_ analysisID: String) {
        let analysisURLString = "https://www.virustotal.com/api/v3/analyses/\(analysisID)"
        guard let analysisURL = URL(string: analysisURLString) else { return }

        var request = URLRequest(url: analysisURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("6a1823664734d2acc436271283edeb7a0a2a596e495a9c0a1b76b8f0da99f0d2", forHTTPHeaderField: "x-apikey")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let meta = jsonResponse["meta"] as? [String: Any],
                   let urlInfo = meta["url_info"] as? [String: Any],
                   let url = urlInfo["url"] as? String,
                   let dataDict = jsonResponse["data"] as? [String: Any],
                   let attributes = dataDict["attributes"] as? [String: Any],
                   let links = dataDict["links"] as? [String: Any],
                   let selfLink = links["self"] as? String,
                   let status = attributes["status"] as? String {

                    print("Analysis Status: \(status)")

                    if status == "completed" {
                        if let stats = attributes["stats"] as? [String: Int] {
                            let malicious = stats["malicious"] ?? 0
                            let suspicious = stats["suspicious"] ?? 0
                            let undetected = stats["undetected"] ?? 0
                            let harmless = stats["harmless"] ?? 0
                            let timeout = stats["timeout"] ?? 0

                            let message = "Malicious: \(malicious), Suspicious: \(suspicious)"
                            showNotification(title: "VirusTotal Scan Complete", message: message)
                            
                            // Create a URLScanResult to store the data
                            let scanResult = URLScanResult(
                                url: url,
                                status: status,
                                link: selfLink,
                                malicious: malicious,
                                suspicious: suspicious,
                                undetected: undetected,
                                harmless: harmless,
                                timeout: timeout
                            )
                            
                            // Save the result locally
                            URLScanHistory.addNewScanResult(scanResult)
                        }
                    } else {
                        // Wait and retry after 5 seconds
                        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                            fetchAnalysisResults(analysisID)
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }
}
