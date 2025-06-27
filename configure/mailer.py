import smtplib
import os
from email.message import EmailMessage
from colorama import Fore, Style, init
import threading
import itertools
import time

init(autoreset=True)

spinner_running = False

def spinner(text):
    global spinner_running
    spinner_running = True
    for c in itertools.cycle("|/-\\"):
        if not spinner_running:
            break
        print(Fore.CYAN + f"\r{text} {c}", end="", flush=True)
        time.sleep(0.1)
    print("\r" + " " * (len(text) + 2) + "\r", end="", flush=True)

def load_smtp():
    t = threading.Thread(target=spinner, args=("Connecting to local mail server",))
    t.start()
    try:
        smtp = smtplib.SMTP("localhost")
    except Exception as e:
        global spinner_running
        spinner_running = False
        t.join()
        print(Fore.RED + f"Failed to connect to local mail server: {e}")
        return None
    spinner_running = False
    t.join()
    print(Fore.GREEN + "✔ Local SMTP connected\n")
    return smtp

def prompt_email():
    msg = EmailMessage()

    # From
    msg['From'] = input(Fore.GREEN + "From: " + Style.RESET_ALL).strip()

    # To
    msg['To'] = input(Fore.GREEN + "Recipient (To): " + Style.RESET_ALL).strip()

    # CC
    cc_choice = input(Fore.GREEN + "Add CC? (y/n): " + Style.RESET_ALL).lower()
    if cc_choice == 'y':
        msg['Cc'] = input(Fore.GREEN + "CC address: " + Style.RESET_ALL).strip()

    # Subject
    msg['Subject'] = input(Fore.GREEN + "Subject: " + Style.RESET_ALL).strip()

    # Body
    print(Fore.GREEN + "Enter message body. End with a single '.' on a line:")
    lines = []
    while True:
        line = input()
        if line == ".":
            break
        lines.append(line)
    msg.set_content("\n".join(lines))

    # Attachments
    attachments = []
    attach_choice = input(Fore.GREEN + "Attach files? (y/n): " + Style.RESET_ALL).lower()
    while attach_choice == 'y':
        path = input(Fore.GREEN + "File path: " + Style.RESET_ALL).strip()
        if os.path.isfile(path):
            with open(path, 'rb') as f:
                data = f.read()
            msg.add_attachment(data, maintype='application', subtype='octet-stream', filename=os.path.basename(path))
            attachments.append(path)
            print(Fore.YELLOW + f"✔ Attached: {path}")
        else:
            print(Fore.RED + "File not found.")
        attach_choice = input(Fore.GREEN + "Add another file? (y/n): " + Style.RESET_ALL).lower()

    return msg

def main():
    smtp = load_smtp()
    if not smtp:
        print(Fore.RED + "Cannot continue without SMTP.")
        return

    msg = prompt_email()
    confirm = input(Fore.GREEN + "\nSend email now? (y/n): " + Style.RESET_ALL).lower()
    if confirm == 'y':
        try:
            smtp.send_message(msg)
            print(Fore.GREEN + Style.BRIGHT + "✔ Email sent successfully.")
        except Exception as e:
            print(Fore.RED + f"Failed to send email: {e}")
    else:
        print(Fore.YELLOW + "✖ Email not sent.")
    smtp.quit()

if __name__ == "__main__":
    main()
    
