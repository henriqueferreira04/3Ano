import argparse
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import padding
import math

# Helper function to split the plaintext into blocks
def plaintext_blocks(plaintext: bytes, modulus_size: int):
    block_size = modulus_size - 11  # Leave space for padding
    for i in range(math.ceil(len(plaintext) / block_size)):
        yield plaintext[i * block_size:(i + 1) * block_size]

def main():
    parser = argparse.ArgumentParser()
    private_public_parser = parser.add_mutually_exclusive_group(required=True)
    parser.add_argument("--plain-text", "-plain", help="File to encrypt")
    private_public_parser.add_argument("--public-key-file", "-pub", help="Public key file (for encryption)")
    private_public_parser.add_argument("--private-key-file", "-priv", help="Private key file (for decryption)")
    parser.add_argument("--encrypted-file", "-encrypted", required=True, help="File to store or read encrypted data")

    args = parser.parse_args()

    if args.public_key_file and args.plain_text:
        # Encryption using the public key
        with open(args.plain_text, "rb") as file:
            message = file.read()

        with open(args.public_key_file, "rb") as file:
            public_key = serialization.load_pem_public_key(file.read())

        modulus_size = public_key.key_size // 8  # Get the key size in bytes

        ciphertext = b""
        for block in plaintext_blocks(message, modulus_size):
            encrypted_block = public_key.encrypt(
                block, 
                padding.PKCS1v15()
            )
            ciphertext += encrypted_block

        with open(args.encrypted_file, "wb") as file:
            file.write(ciphertext)

    elif args.private_key_file:
        # Decryption using the private key
        with open(args.encrypted_file, "rb") as file:
            message = file.read()

        with open(args.private_key_file, "rb") as file:
            private_key = serialization.load_pem_private_key(file.read(), password=None)

        modulus_size = private_key.key_size // 8  # Get the key size in bytes

        plaintext = b""
        for i in range(0, len(message), modulus_size):
            block = message[i:i + modulus_size]
            decrypted_block = private_key.decrypt(
                block, 
                padding.PKCS1v15()
            )
            plaintext += decrypted_block

        with open("plaintext_decrypted.txt", "wb") as file:
            file.write(plaintext)

if __name__ == '__main__':
    main()


