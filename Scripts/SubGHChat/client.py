from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
import os
import socket
import threading
import time
import hashlib
import base64
import subprocess
import sys
import platform

# Function to install required packages


def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

# Function to check Python version


def check_python_version():
    if sys.version_info < (3, 6):
        print("Python 3.6 or higher is required. Please update Python.")
        sys.exit(1)

# Function to check pip version


def check_pip_version():
    try:
        pip_version = subprocess.check_output(
            [sys.executable, "-m", "pip", "--version"]).decode()
        print("Found pip version:", pip_version)
    except Exception as e:
        print("Error finding pip:", str(e))
        print("Ensure pip is installed.")
        sys.exit(1)

# Function to validate and install necessary packages


def check_packages():
    try:
        import cryptography  # Try importing the library
    except ImportError:
        print("Package 'cryptography' not found. Installing...")
        install("cryptography")


# Check Python, pip versions, and required packages
check_python_version()
check_pip_version()
check_packages()


class SubGHzChat:
    def __init__(self):
        self.encryption_enabled = False
        self.key = None
        self.counter = {}
        self.id = None
        self.frequency = None
        self.socket = None
        self.chat_thread = None
        self.stop_thread = False

    def derive_key(self, method):
        if method == 'No encryption':
            self.encryption_enabled = False
            print("Encryption disabled.")
            return
        elif method == 'Generate Key':
            self.key = os.urandom(32)  # 256 bits
            self.encryption_enabled = True
            print(f"Generated key: {base64.b64encode(self.key).decode()}")
        elif method in ['Password', 'Hex Key']:
            if method == 'Password':
                password = input("Enter your password: ")
                self.key = hashlib.sha256(password.encode()).digest()
            elif method == 'Hex Key':
                hex_key = input("Enter your hex key (64 hex digits): ")
                self.key = bytes.fromhex(hex_key)
            self.encryption_enabled = True

    def get_frequency(self):
        while True:
            freq_input = input(
                "Enter frequency to operate (in Hz, default is 2.4GHz): ")
            if freq_input == "":
                self.frequency = 2400000000  # Default frequency
                print("Default frequency (2.4GHz) selected.")
                break
            try:
                self.frequency = int(freq_input)
                if self.frequency <= 0:
                    raise ValueError
                break
            except ValueError:
                print("Invalid frequency. Please enter a positive integer.")

    def generate_id(self):
        # Use platform.node() for cross-platform compatibility
        system_name = platform.node()
        timestamp = str(time.time()).encode()
        self.id = hashlib.sha256(system_name.encode() + timestamp).hexdigest()

    def encrypt_message(self, message):
        iv = os.urandom(12)  # GCM mode requires a 12-byte IV
        encryptor = Cipher(algorithms.AES(self.key), modes.GCM(
            iv), backend=default_backend()).encryptor()

        # Prefix the message with ID and counter
        counter_value = self.counter.get(self.id, 0) + 1
        self.counter[self.id] = counter_value
        message_prefix = f"{self.id}:{
            counter_value}:".encode() + message.encode()
        ciphertext = encryptor.update(message_prefix) + encryptor.finalize()
        return iv + encryptor.tag + ciphertext

    def decrypt_message(self, encrypted_message):
        iv = encrypted_message[:12]
        tag = encrypted_message[12:28]
        ciphertext = encrypted_message[28:]

        decryptor = Cipher(algorithms.AES(self.key), modes.GCM(
            iv, tag), backend=default_backend()).decryptor()
        try:
            decrypted_message = decryptor.update(
                ciphertext) + decryptor.finalize()
        except Exception as e:
            print("Decryption failed:", str(e))
            return None

        # Extract ID and counter from the decrypted message
        message_parts = decrypted_message.split(b':', 2)
        if len(message_parts) < 3:
            print("Invalid message format.")
            return None

        msg_id, msg_counter = message_parts[0], int(message_parts[1])

        # Check for replay attacks
        if msg_id.decode() in self.counter and self.counter[msg_id.decode()] >= msg_counter:
            print("Replay attack detected! Message discarded.")
            return None
        self.counter[msg_id.decode()] = msg_counter

        return message_parts[2].decode()

    def send_message(self):
        while True:
            message = input(
                "Enter your message (or press Ctrl+B to view chat): ")
            if message == '':
                print("Viewing chat... (Ctrl+C to exit)")
                continue
            if self.encryption_enabled:
                encrypted_msg = self.encrypt_message(message)
                self.socket.sendall(encrypted_msg)
            else:
                self.socket.sendall(message.encode())

    def receive_message(self):
        while not self.stop_thread:
            try:
                data = self.socket.recv(1024)
                if not data:
                    break
                if self.encryption_enabled:
                    decrypted_msg = self.decrypt_message(data)
                    if decrypted_msg:
                        print(f"Received: {decrypted_msg}")
                else:
                    print(f"Received: {data.decode()}")
            except Exception as e:
                print("Error receiving message:", str(e))
                break

    def start_chat(self):
        host = input(
            "Enter the server's IP address (or 'localhost' if local): ")
        port = 12345

        # Create a TCP/IP socket
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            self.socket.connect((host, port))
        except Exception as e:
            print(f"Failed to connect to {host}:{port}. Error: {e}")
            return

        # Start threads for sending and receiving messages
        self.stop_thread = False
        self.chat_thread = threading.Thread(target=self.receive_message)
        self.chat_thread.start()

        try:
            self.send_message()
        except KeyboardInterrupt:
            print("Exiting chat...")

        self.stop_thread = True
        self.chat_thread.join()
        self.socket.close()


def main():
    chat = SubGHzChat()

    print("Welcome to Sub-GHz Chat")

    # Step 1: Choose encryption method
    print("Select encryption method:")
    print("1. No encryption")
    print("2. Generate Key")
    print("3. Password")
    print("4. Hex Key")

    option = input("Enter your choice (1-4): ")
    methods = {
        '1': 'No encryption',
        '2': 'Generate Key',
        '3': 'Password',
        '4': 'Hex Key'
    }

    if option in methods:
        chat.derive_key(methods[option])
    else:
        print("Invalid choice. Exiting.")
        return

    # Step 2: Get frequency
    chat.get_frequency()

    # Step 3: Generate ID
    chat.generate_id()

    # Step 4: Start chat
    chat.start_chat()


if __name__ == "__main__":
    main()
