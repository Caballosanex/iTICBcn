import socket
import threading

clients = []  # Llista per guardar els clients connectats


def handle_client(conn, addr):
    print(f"New connection from {addr}")
    while True:
        try:
            data = conn.recv(1024)
            if not data:
                break
            # Rebre i reenviar el missatge a tots els clients
            print(f"Received from {addr}: {data.decode()}")
            broadcast(data, conn)
        except ConnectionResetError:
            break
    conn.close()
    # Elimina el client de la llista quan es desconnecta
    if conn in clients:
        clients.remove(conn)
    print(f"Connection closed from {addr}")


def broadcast(message, sender_conn):
    # Enviar el missatge a tots els clients menys al remitent
    for client in clients:
        if client != sender_conn:
            try:
                client.sendall(message)
            except Exception as e:
                print(f"Error sending message to {client}: {str(e)}")
                # Si hi ha un error, elimina el client de la llista
                clients.remove(client)


def start_server(host):
    port = 12345
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind((host, port))
    server_socket.listen()
    print("Server listening on port", port)

    while True:
        conn, addr = server_socket.accept()
        clients.append(conn)
        threading.Thread(target=handle_client, args=(conn, addr)).start()


def server_send_message():
    while True:
        message = input("Server message: ")
        if message:
            broadcast(message.encode(), None)


if __name__ == "__main__":
    host = input("Enter the host IP address: ")
    threading.Thread(target=server_send_message).start()
    start_server(host)
	