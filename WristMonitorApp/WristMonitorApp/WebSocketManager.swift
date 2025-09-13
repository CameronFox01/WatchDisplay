//
//  WebSocketManager.swift
//  WristMonitorApp
//
//  Created by Cameron Fox on 9/12/25.
//

import Foundation

class WebSocketManager: ObservableObject {
    private var task: URLSessionWebSocketTask?
    @Published var latestData: ComputerData?

    func connect() {
        let url = URL(string: "ws://10.0.0.105:8765")! // change later if testing on iPhone
        task = URLSession(configuration: .default).webSocketTask(with: url)
        task?.resume()
        receive()
    }

    func disconnect() {
        task?.cancel(with: .goingAway, reason: nil)
    }

    private func receive() {
        task?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error receiving: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        do {
                            let decoded = try JSONDecoder().decode(ComputerData.self, from: data)
                            DispatchQueue.main.async {
                                self?.latestData = decoded
                            }
                        } catch {
                            print("Decoding error: \(error)")
                        }
                    }
                default:
                    break
                }
            }
            self?.receive()
        }
    }
}
