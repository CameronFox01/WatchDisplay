# WristMonitor
WristMonitor is a cross-platform project that turns your Apple Watch into a **tiny, glanceable system dashboard** for your Windows computer.  
It lets you flow through different "windows" (views) on the Watch to see system and developer metrics in real time.

---

## 🚀 Features

Each metric is its own view on the Watch that you can swipe/scroll through:

- **CPU Usage** – current usage percentage, per-core stats (optional).
- **Memory (RAM) Usage** – used vs. total memory, live percentage.
- **GPU Usage** – utilization %, useful for gaming or development.
- **Network Speed** – current upload/download throughput.
- **Disk Usage / I/O** – free space and disk activity.
- **Battery Status** – laptop battery % and health.
- **Build/Compile Status** – receive success/failure indicators from your dev environment.
- **Server Monitoring** – optional ping/uptime for a server or service you care about.

---

## 🏗️ Architecture

The system has three layers:

1. **Windows app (Python)**  
   - Collects system metrics (using libraries like `psutil`, `GPUtil`, `speedtest-cli`, etc.).  
   - Runs a lightweight **WebSocket server** to stream data.  

2. **iPhone app (Swift)**  
   - Connects to the Windows server over Wi-Fi.  
   - Parses JSON data and manages communication.  
   - Relays the data to the Apple Watch app.  

3. **Apple Watch app (SwiftUI)**  
   - Displays one metric per screen ("window").  
   - User can swipe/scroll through windows (CPU, RAM, GPU, etc.).  
   - Refreshes metrics in near real time.  

---

## 🛠️ Tech Stack

- **Windows (backend)**: Python  
  - `psutil` (CPU, RAM, disk)  
  - `GPUtil` (GPU)  
  - `websockets` (for real-time server)  
  - `speedtest-cli` or `psutil.net_io_counters()` for network  

- **iOS + watchOS (frontend)**: Swift + SwiftUI  
  - `Network` or `Starscream` (WebSocket client)  
  - `WatchConnectivity` (bridge iPhone ↔ Watch)  
  - SwiftUI views for metric windows  

---

## 🔌 Communication Protocol

- **Format**: JSON messages  
- Example update packet:

```json
{
  "cpu": 37.5,
  "ram": 62.1,
  "gpu": 14.8,
  "network": { "upload": 3.2, "download": 45.6 },
  "disk": { "used": 512, "total": 1000 },
  "battery": 89,
  "build_status": "success"
}
```
## 📱 User Flow

1. **Start the Windows Server**
   - On your Windows PC, launch the Python backend (`server.py`).
   - The server begins collecting metrics (CPU, RAM, GPU, etc.) and starts broadcasting them over WebSockets.

2. **Open the iOS App**
   - On your iPhone, open the WristMonitor app.
   - Enter the Windows machine’s IP address (or have it auto-discovered on the LAN).
   - The app establishes a connection to the Windows server.

3. **Data Synchronization**
   - The iOS app receives JSON packets from the Windows server.
   - Data is parsed, cached, and relayed to the Apple Watch using WatchConnectivity.

4. **Use the Watch App**
   - On the Watch, open WristMonitor.
   - Swipe or scroll through the available "windows":
     - CPU → RAM → GPU → Network → Disk → Battery → Build Status → Server Monitor
   - Each view updates in near real-time as new packets arrive.

5. **Close / Background**
   - If the iOS app is backgrounded, it will attempt to keep the connection alive for as long as iOS allows.
   - When the Watch app is closed, metrics stop updating until reopened.

---

## ⚠️ Limitations / Future Work

### Current Limitations
- **Local Network Requirement**  
  iPhone and Windows PC must be on the same Wi-Fi/LAN unless you manually expose the server to the internet.
- **Performance**  
  Update frequency is limited (e.g. ~1s refresh) to conserve Watch battery life and avoid network congestion.
- **GPU Monitoring**  
  GPU stats depend on `GPUtil` and vendor drivers. May not work on all hardware (especially integrated GPUs).
- **Battery Monitoring**  
  Battery health/charge data may vary in accuracy depending on hardware and OS support.
- **Background Restrictions**  
  iOS aggressively suspends apps in the background; continuous updates may stop if the iOS app is not foregrounded.

### Future Work
- **Customizable Windows**  
  Allow users to select which metrics appear and in what order.
- **Threshold Alerts**  
  Push notifications when CPU, RAM, or GPU exceed set limits (e.g. CPU > 90%).
- **Historical Graphs**  
  Add lightweight history views on Watch (e.g. CPU usage over last 10 minutes).
- **Cross-Network Support**  
  Enable secure cloud relay so metrics can be viewed when away from the same Wi-Fi.
- **Developer Integrations**  
  Add integrations for build pipelines (GitHub Actions, Jenkins, etc.) for live CI/CD status updates.
- **Watch-Only Mode**  
  Offload more logic to the Watch app so it can fetch metrics directly via the iPhone, even if the iPhone app isn’t open.

