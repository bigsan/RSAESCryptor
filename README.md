# RSA+AES Cryptor

RSA+AES Encryption/Decryption library for iOS. This library uses 2048-bit RSA and 256-bit key with 128-bit block size AES for encryption/decryption.

## Encryption
Load public key from X509 Certificate file (DER format), encrypt NSData using AES algorithm with generated Key and IV, returns encrypted NSData with format below.

    | AES IV | encrypted AES Key | AES encrypted data |
    |  0-15  |       16-271      |        272-n       |

Sample code:

	
	NSString *pubKeyPath = [[NSBundle mainBundle] pathForResource:@"publicKey" ofType:@"cer"];
	
	RSAESCryptor *cryptor = [RSAESCryptor sharedCryptor];
	[cryptor loadPublicKey:pubKeyPath];
	NSData *encData = [cryptor encryptData:plainData];
	
	// encrypted data format:
	// [16 bytes IV] + [256 bytes encrypted Key] + [AES encrypted data].
   
## Decryption
Load private key from PKCS#12/PFX format file, decrypt NSData according to the format described above.

	NSString *priKeyPath = [[NSBundle mainBundle] pathForResource:@"privateKey" ofType:@"p12"];
	
	RSAESCryptor *cryptor = [RSAESCryptor sharedCryptor];
	[cryptor loadPrivateKey:priKeyPath password:password];
	NSData *decData = [cryptor decryptData:encData];


## How to create .cer and .p12 in Windows

	1. Open Visual Studio Command Prompt
	2. C:\> makecert -pe -ss My -sr LocalMachine -n CN="YOUR_CERT_NAME" -sky exchange
	3. C:\> mmc
	4. Add Certificates snap-in in MMC console, choose computer accounts
	5. expand Personal/Certificate folder, then export which you want.

## How to decrypt using C\# (File-based cert)

	// get cert from pfx file.
	var pfxFileName = @"C:\privateKey.p12";	var password = @"PFX_PASSWORD";	var cert = new X509Certificate2(pfxFileName, password);	var rsa = (RSACryptoServiceProvider)cert.PrivateKey;
	byte[] data = SomeClass.GetRSAESCryptorEncryptedByteArray();		var iv = data.Take(16).ToArray();	var encSymKey = data.Skip(16).Take(256).ToArray();	var encData = data.Skip(16 + 256).ToArray();		var symKey = rsa.Decrypt(encSymKey, false);
	var aes = AesManaged.Create();	using (var inStream = new CryptoStream(new MemoryStream(encData), aes.CreateDecryptor(symKey, iv), CryptoStreamMode.Read))	{		// read data from inStream	}
## How to get cert from Certificate Store in Windows
	// get cert from X.509 store of local machine	var store = new X509Store(StoreLocation.LocalMachine);
	store.Open(OpenFlags.ReadOnly);
	var cert = store.Certificates.Cast<X509Certificate2>()
				.FirstOrDefault(c => c.Subject == "CN=YOUR_CERT_NAME");
	store.Close();
