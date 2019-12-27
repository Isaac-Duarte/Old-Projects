# Imports
from Crypto.PublicKey import RSA
from Crypto.Random import get_random_bytes
from Crypto.Cipher import Salsa20, PKCS1_OAEP

class Crypter:
    """This allows for encryption of strings/files.

    This class uses RSA and Salsa20 to encrypt files.
    """

    def generate_keys(self, bits=2048):
        """This will generate a public and private key.
        
        Returns:
            str: The Public Key that was generated.
            str: The Private Key that was generated.
        """
        # Generate the key.
        key = RSA.generate(bits)

        # Get the public and private key.
        public_key = key.publickey().export_key()
        private_key = key.export_key()

        return public_key, private_key

    def encrypt(self, data, pub_key):
        """This will encrypt a data with a pub_key.
    
        Args:
            data: The data wanting to be encrypted.
            pub_key: The reciever public key. (RSA)
        
        Returns:
            str: The encrypted session key.
            str: The nounce.
            str: The encrypted data.
        """
        # Make it so we can pass a data through the Cipher.
        if isinstance(data, str):
            data = data.encode("utf-8")

        # Getting the RSA Key and session_key
        recipient_key = RSA.import_key(pub_key)
        session_key = get_random_bytes(32)

        # Encrypt the session key with the RSA key.
        cipher_rsa = PKCS1_OAEP.new(recipient_key)
        enc_session_key = cipher_rsa.encrypt(session_key)

        # Encrypt the data with Salsa20.
        cipher_salsa20 = Salsa20.new(key=session_key)
        ciphertext = cipher_salsa20.encrypt(data)

        return enc_session_key, cipher_salsa20.nonce, ciphertext
    
    def decrypt(self, enc_session_key, nonce, ciphertext, priv_key):
        """This will decrypt encrypted data.
    
        Args:
            enc_session_key: The encrypted session key returned from the encrypt function.
            nonce: The nonce returned by the encrypt function.
            ciphertext: The ciphertext returned by the encrypt function. 
            priv_key: The private key. (Receiver)
        
        Returns:
            string: The encrypted data.
        """
        # Gettings the RSA private key.
        private_key = RSA.import_key(priv_key)

        # Decrypt the session key with the private_key.
        cipher_rsa = PKCS1_OAEP.new(private_key)
        session_key = cipher_rsa.decrypt(enc_session_key)

        # Decrypt the data iwth the Salsa20 session key.
        cipher_salsa20 = Salsa20.new(key=session_key, nonce=nonce)
        data = cipher_salsa20.decrypt(ciphertext)

        return data
    
    def encrypt_file(self, path, pub_key):
        """This will encrypt a file.
    
        Args:
            path: This is the path to the file wanting to be encrypted.
            pub_key: The reciever public key. (RSA)
        
        Returns:
            str: The encrypted session key.
            str: The nounce.
            str: The encrypted data.
        """
        with open(path, "rb") as file:
            # Getting that data from the file.
            data = file.read()
            file.close()

            # Getting the RSA Key and session_key
            recipient_key = RSA.import_key(pub_key)
            session_key = get_random_bytes(32)

            # Encrypt the session key with the RSA key.
            cipher_rsa = PKCS1_OAEP.new(recipient_key)
            enc_session_key = cipher_rsa.encrypt(session_key)

            # Encrypt the data with Salsa20.
            cipher_salsa20 = Salsa20.new(key=session_key)
            ciphertext = cipher_salsa20.encrypt(data)

            return enc_session_key, cipher_salsa20.nonce, ciphertext
        
        return False

    def decrypt_file(self, path, priv_key):
        """This will decrypt a file.
    
        Args:
            path: This is the path to the file wanting to be encrypted.
            priv_key: The private key. (Receiver)
        
        Returns:
            str: The decrypted data.
        """
        with open(path) as file:
            # Gettings the RSA private key.
            private_key = RSA.import_key(priv_key)

            # Getting the information from the file.
            size = private_key.size_in_bytes()
            enc_session_key, nonce, ciphertext = [file.read(value) for value in (size, 8, -1)]
            file.close()
            
            # Decrypt the session key with the private_key.
            cipher_rsa = PKCS1_OAEP.new(private_key)
            session_key = cipher_rsa.decrypt(enc_session_key)

            # Decrypt the data iwth the Salsa20 session key.
            cipher_salsa20 = Salsa20.new(key=session_key, nonce=nonce)
            data = cipher_salsa20.decrypt(ciphertext)

            return data
        
        return False
