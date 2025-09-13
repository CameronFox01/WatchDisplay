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
                if let data = wsManager.latestData {
                    HStack {
                        Text("CPU Usage")
                        Spacer()
                        Text("\(data.cpu_usage, specifier: "%.2f")%")
                    }
                    HStack {
                        Text("Memory Usage")
                        Spacer()
                        Text("\(data.memory_usage, specifier: "%.2f")%")
                    }
                    if let cDrive = data.c_drive {
                        HStack {
                            Text("C Drive Usage")
                            Spacer()
                            Text("\(cDrive, specifier: "%.2f")%")
                        }
                    }
                    if let dDrive = data.d_drive {
                        HStack {
                            Text("D Drive Usage")
                            Spacer()
                            Text("\(dDrive, specifier: "%.2f")%")
                        }
                    }
                    HStack {
                        Text("Network Sent")
                        Spacer()
                        Text("\(data.network_io.bytes_sent)")
                    }
                    HStack {
                        Text("Network Received")
                        Spacer()
                        Text("\(data.network_io.bytes_recv)")
                    }
                    if let battery = data.battery_status {
                        HStack {
                            Text("Battery")
                            Spacer()
                            Text("\(battery.percent)%")
                        }
                        HStack {
                            Text("Plugged in")
                            Spacer()
                            Text(battery.power_plugged ? "Yes" : "No")
                        }
                    }
                }
            }
            .navigationTitle("PC Metrics")
        }
        .onAppear { wsManager.connect() }
        .onDisappear { wsManager.disconnect() }
    }
}

#Preview {
    ContentView()
}
