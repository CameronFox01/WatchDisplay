//
//  WebSocketManager.swift
//  WristMonitorApp
//
//  Created by Cameron Fox on 9/12/25.
//

import Foundation

class WebSocketManager: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    
    @Published var latestData: [String: Any] = [:]
    
    func connect() {
        let url = URL(string: "ws://10.0.0.105:8765")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receive()
    }
    
    func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                                DispatchQueue.main.async {
                                    self?.latestData = json
                                    print("Received: \(json)")
                                }
                            }
                        } catch {
                            print("JSON parse error: \(error)")
                        }
                    }
                default:
                    break
                }
            case .failure(let error):
                print("WebSocket error: \(error)")
            }
            
            // Continue listening
            self?.receive()
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
