#Author is Cameron Fox
# This is a local machine test file for the WristMonitor project.
import asyncio
import websockets

async def test():
    uri = "ws://localhost:8765"
    async with websockets.connect(uri) as websocket:
        for _ in range(3):  # read 3 messages
            message = await websocket.recv()
            print(message)

asyncio.run(test())