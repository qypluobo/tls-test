import ssl,socket

context = ssl.create_default_context()
context = ssl.SSLContext()
context.verify_mode = ssl.CERT_REQUIRED
context.check_hostname = True
context.load_verify_locations(cafile="rootca.pem")
conn = context.wrap_socket(socket.socket(socket.AF_INET), server_hostname='server')
conn.connect(("192.168.1.11", 7275))
cert = conn.getpeercert()
print(cert)