#!/bin/bash

# Get user information
read -p "Please enter your API ID: " API_ID
read -p "Please enter your API Hash: " API_HASH
read -p "Please enter your phone number: " PHONE_NUMBER
read -p "Please enter the channel username: " CHANNEL_USERNAME
read -p "Please enter your message: " MESSAGE

# Create Python script
cat << EOF > telegram_script.py
from telethon import TelegramClient, events
import asyncio

api_id = '$API_ID'
api_hash = '$API_HASH'
phone_number = '$PHONE_NUMBER'
channel_username = '$CHANNEL_USERNAME'
message = '$MESSAGE'

client = TelegramClient('session_name', api_id, api_hash)

async def main():
    await client.start(phone_number)
    me = await client.get_me()
    print(f'Logged in as {me.username} ({me.id})')

    @client.on(events.NewMessage(incoming=True))
    async def handler(event):
        if event.is_private:  # Check if the message is from a private chat
            sender = await event.get_sender()
            if not sender.bot:  # Check if the sender is not a bot
                await event.respond('سلام، در اسرع وقت پاسخگوی شما خواهم بود.')
                print(f'Responded to {sender.id}')

    while True:
        await client.send_message(channel_username, message)
        await asyncio.sleep(5)

with client:
    client.loop.run_until_complete(main())
EOF

# Run Python script
python3 telegram_script.py
