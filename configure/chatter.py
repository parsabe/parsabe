
import requests
import json
import colorama
from colorama import Fore, Style

colorama.init(autoreset=True)

# ── SAIA API Configuration ──
API_KEY = "b5240853f6c0c3a0fb720ab58c34e115"
API_URL = "https://chat-ai.academiccloud.de/v1/chat/completions"
MODEL   = "meta-llama-3.1-8b-instruct"

HEADERS = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {API_KEY}"
}

chat_history = []

def print_separator():
    print(Fore.WHITE + Style.DIM + "-" * 60)

def send_message(user_message):
    chat_history.append({"role": "user", "content": user_message})

    payload = {
        "model": MODEL,
        "messages": chat_history,
        "temperature": 0.7
    }

    response = requests.post(API_URL, headers=HEADERS, data=json.dumps(payload))

    if response.status_code == 200:
        result = response.json()
        reply = result['choices'][0]['message']['content']
        chat_history.append({"role": "assistant", "content": reply})
        return reply.strip()
    else:
        return f"[Error {response.status_code}]: {response.text}"

# ── Main Chat Loop ──
print_separator()
print(Fore.CYAN + Style.BRIGHT + "Chat-AI Terminal — Interactive Mode")
print(Fore.WHITE + Style.DIM + "Press Ctrl+C to exit anytime.")
print_separator()

try:
    while True:
        user_input = input(Fore.GREEN + Style.BRIGHT + "You: " + Style.RESET_ALL)
        if not user_input.strip():
            continue

        print_separator()
        reply = send_message(user_input)
        print(Fore.YELLOW + Style.BRIGHT + "AI:\n" + Style.RESET_ALL + reply)
        print_separator()

except KeyboardInterrupt:
    print("\n" + Fore.RED + Style.BRIGHT + "[Session Ended]")

