# Server side of WristMonitor
# Author is Cameron Fox
# Date is 09/12/2025
# Description: This file sets up a WebSocket server to send system metrics to connected clients.
import asyncio
import websockets
import json
import main  # your main.py file

async def handler(websocket):
    while True:
        data = main.get_computer_data()
        await websocket.send(json.dumps(data))
        await asyncio.sleep(1)  # send every second

async def run_server():
    async with websockets.serve(handler, "0.0.0.0", 8765):
        print("Server running at ws://0.0.0.0:8765")
        await asyncio.Future()  # run forever

if __name__ == "__main__":
    asyncio.run(run_server())   
