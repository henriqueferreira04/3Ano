import os
from utils import load_cert
from validity_check import valid
from cryptography import x509


def trusted(dir_name: str) -> dict:
    """This function reads all the certificates saved in the given directory, returning them in a dictionary
    
    Args:
        dir_name (str): directory name where the certificates are saved

    Returns:
        dict: dictionary with keys as the certificates subjects and as values the corresponding certificates

    """
    result = {}

    #de = directory entries
    for de in os.scandir(dir_name):
        if de.is_file():
            with open(de.path, "rb") as f:
                cert = load_cert(de.path)
                if valid(cert):
                    result[cert.subject] = cert
                

    return result

def main():
    trust_certs = trusted("/etc/ssl/certs")
    print(f"{len(trust_certs)} valid trusted certificates found")
            

if __name__ == "__main__":
    main()
