from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
import os


accepted_modes = {
    'ECB' : modes.ECB,
    'CBC' : modes.CBC
}

modes_with_iv = {'CBC'}

def getPadding(plaintext: bytes):
    padding_n = 16 - (len(plaintext) % 16)
    text_padded =plaintext + bytes([padding_n]) * padding_n

    return text_padded

def cipher(key: bytes, plaintext: bytes, mode: str, iv: bytes = None):
    
    
    text_padded = getPadding(plaintext)

    padding_n = len(text_padded) - len(plaintext)

    cipher = Cipher(algorithm=algorithms.AES128(key), mode=accepted_modes[mode](iv) if mode in mode and iv else accepted_modes[mode]())

    encryptor = cipher.encryptor()

    ciphertext = encryptor.update(text_padded) + encryptor.finalize()

    return (ciphertext, padding_n)


def decipher(key: bytes, ciphertext: bytes, mode: str, iv: bytes = None):

    
    cipher = Cipher(algorithm=algorithms.AES128(key), mode=accepted_modes[mode](iv) if mode in mode and iv else accepted_modes[mode]())

    decryptor = cipher.decryptor()
    
    index = len(ciphertext[0])-ciphertext[1]
    plaintext = decryptor.update(ciphertext[0]) + decryptor.finalize()


    return plaintext[:index]


def read_file(filepath: str) -> bytes:

    with open(filepath, 'rb') as file:
        return file.read()

def write_file(filepath: str, data: bytes):

    with open(filepath, 'wb') as file:
        file.write(data)

def main():

    key = os.urandom(16)
    iv = os.urandom(16)
    
    input_file = 'Tux.bmp'
    encrypted_ecb_file = 'Tux_enc_ECB.bmp'
    decrypted_ecb_file = 'Tux_dec_ECB.bmp'
    encrypted_CBC_file = 'Tux_enc_CBC.bmp'
    decrypted_CBC_file = 'Tux_dec_CBC.bmp'

    plaintext = read_file(input_file)
    
    mode = 'ECB'
    print("ECB: ")
    ciphertext = cipher(key=key, plaintext=plaintext, mode=mode)
    
    print(ciphertext)
    write_file(encrypted_ecb_file, ciphertext[0])

    deciphertext = decipher(key=key, ciphertext=ciphertext, mode=mode)
    #print(deciphertext)
    write_file(decrypted_ecb_file, deciphertext)

    ###########
    mode = 'CBC'
    print("\nCBC: ")
    
    ciphertext = cipher(key=key, plaintext=plaintext, mode=mode, iv=iv)
    
    #print(ciphertext)
    write_file(encrypted_CBC_file, ciphertext[0])

    deciphertext = decipher(key=key,ciphertext=ciphertext, mode=mode, iv=iv)
    #print(deciphertext)
    write_file(decrypted_CBC_file, deciphertext)

if __name__ == "__main__":
    main()


