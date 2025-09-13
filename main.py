# Author is Cameron Fox
# Date is 09/12/2025
# Description: This is the main file for the WristMonitor project.

import psutil
import json



def get_computer_data():
    computer_data = {
        "cpu_usage": psutil.cpu_percent(interval=1),
        "memory_usage": psutil.virtual_memory().percent,
        "c_drive": psutil.disk_usage("C:\\").percent,
        "d_drive": psutil.disk_usage("D:\\").percent,
        "network_io": {
            "bytes_sent": psutil.net_io_counters().bytes_sent,
            "bytes_recv": psutil.net_io_counters().bytes_recv,
        },
        "battery_status": None,
    }

    battery = psutil.sensors_battery()
    if battery:
        computer_data["battery_status"] = {
            "percent": battery.percent,
            "power_plugged": battery.power_plugged,
        }

    return computer_data


def main():
    data = get_computer_data()

    # Pretty print values
    print(f"CPU usage: {data['cpu_usage']}%")
    print(f"Memory usage: {data['memory_usage']}%")
    print(f"C drive usage: {data['c_drive']}%")
    print(f"D drive usage: {data['d_drive']}%")
    print(f"Bytes sent: {data['network_io']['bytes_sent']}, "
          f"Bytes received: {data['network_io']['bytes_recv']}")

    if data["battery_status"]:
        print(f"Battery percentage: {data['battery_status']['percent']}%, "
              f"Plugged in: {data['battery_status']['power_plugged']}")
    else:
        print("No battery information available.")

    # JSON output
    print(json.dumps(data))


if __name__ == "__main__":
    main()
