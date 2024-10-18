import socket


def start_server():
    host = 'localhost'  # Change to your IP if needed
    port = 12345

    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((host, port))
    server_socket.listen(1)

    print("Server listening on port", port)
    conn, addr = server_socket.accept()
    print(f"Connected by {addr}")

    while True:
        data = conn.recv(1024)
        if not data:
            break
        print(f"Received from client: {data.decode()}")
        # Optionally send a response back to the client
        conn.sendall(data)  # Echo back for testing

    conn.close()
    server_socket.close()


if __name__ == "__main__":
    start_server()