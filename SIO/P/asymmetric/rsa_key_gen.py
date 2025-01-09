import argparse
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--private-key-file", "-priv", required=True, help="File name where to save the generated private key")
    parser.add_argument("--public-key-file", "-pub", required=True, help="File name where to save the generated public key")
    parser.add_argument("--size", "-s", required=True, type=int, help="Size of the RSA modulus")

    args = parser.parse_args()

    private_key = rsa.generate_private_key(public_exponent=65537, key_size=args.size,)
    public_key = private_key.public_key()

    pem = private_key.private_bytes(encoding=serialization.Encoding.PEM, format=serialization.PrivateFormat.PKCS8, encryption_algorithm=serialization.NoEncryption())


    with open(args.private_key_file, 'wb') as file:
        file.write(pem)


    pem = public_key.public_bytes(encoding=serialization.Encoding.PEM, format=serialization.PublicFormat.SubjectPublicKeyInfo)

    with open(args.public_key_file, "wb") as file:
        file.write(pem)


if __name__ == '__main__':
    main()