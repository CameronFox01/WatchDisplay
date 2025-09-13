//
//  struct.swift
//  WristMonitorApp
//
//  Created by Cameron Fox on 9/13/25.
//

struct ComputerData: Codable {
    let cpu_usage: Double
    let memory_usage: Double
    let c_drive: Double?
    let d_drive: Double?
    let network_io: NetworkIO
    let battery_status: BatteryStatus?
}

struct NetworkIO: Codable {
    let bytes_sent: Int
    let bytes_recv: Int
}

struct BatteryStatus: Codable {
    let percent: Int
    let power_plugged: Bool
}
