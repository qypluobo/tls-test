import socket, ssl, select

def deal_with_client(connstream):
    inputs = [connstream]
    outputs = []
    while True:
        r_list, w_list, e_list = select.select(inputs, outputs, inputs, 1)
        for sock in r_list:
            if sock == connstream:
                try:
                    data = connstream.recv(1024)
                except Exception as ex:
                    # 如果用户终止连接
                    break
                else:
                    print(data)

def main():
    context = ssl.create_default_context()
    context.check_hostname = False
    context.verify_mode = ssl.CERT_NONE
    context.load_cert_chain(certfile="server.pem", keyfile="server.key") # need key without password

    print('Create socket')
    bindsocket = socket.socket()
    bindsocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    bindsocket.bind(('192.168.1.11', 7275))

    print('Listenning...')
    bindsocket.listen()

    while True:
        newsocket, fromaddr = bindsocket.accept()
        print(fromaddr)
        connstream = context.wrap_socket(newsocket, server_side=True)
        try:
            deal_with_client(connstream)
        finally:
            connstream.shutdown(socket.SHUT_RDWR)
            connstream.close()

    print('Exited!')

if __name__ == '__main__':
    main()