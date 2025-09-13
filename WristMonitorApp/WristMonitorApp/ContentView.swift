//
//  ContentView.swift
//  WristMonitorApp
//
//  Created by Cameron Fox on 9/12/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var wsManager = WebSocketManager()
    
    var body: some View {
        NavigationView {
            List {
                if let cpu = wsManager.latestData["cpu_usage"] {
                    HStack {
                        Text("CPU Usage")
                        Spacer()
                        Text("\(cpu)%")
                    }
                }
                if let memory = wsManager.latestData["memory_usage"] {
                    HStack {
                        Text("Memory Usage")
                        Spacer()
                        Text("\(memory)%")
                    }
                }
                if let disk = wsManager.latestData["disk_usage"] {
                    HStack {
                        Text("Disk Usage")
                        Spacer()
                        Text("\(disk)%")
                    }
                }
                if let network = wsManager.latestData["network_io"] as? [String: Any] {
                    HStack {
                        Text("Network Sent")
                        Spacer()
                        Text("\(network["bytes_sent"] ?? 0)")
                    }
                    HStack {
                        Text("Network Received")
                        Spacer()
                        Text("\(network["bytes_recv"] ?? 0)")
                    }
                }
                if let battery = wsManager.latestData["battery_status"] as? [String: Any],
                   let percent = battery["percent"] {
                    HStack {
                        Text("Battery")
                        Spacer()
                        Text("\(percent)%")
                    }
                }
            }
            .navigationTitle("PC Metrics")
        }
        .onAppear {
            wsManager.connect()
        }
        .onDisappear {
            wsManager.disconnect()
        }
    }
}
#Preview {
    ContentView()
}
