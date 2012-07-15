//
//  RSAESCryptorTests.m
//  RSAESCryptorTests
//
//  Created by San Chen on 7/15/12.
//  Copyright (c) 2012 Learningtech. All rights reserved.
//

#import "RSAESCryptorTests.h"
#import "RSAESCryptor.h"

@implementation RSAESCryptorTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testMain
{
    NSString *pubKeyPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"RSAESCryptorTest" ofType:@"cer"];
    NSString *priKeyPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"RSAESCryptorTest" ofType:@"p12"];
    NSString *password = @"test";
    NSString *textData = @"Data";

    RSAESCryptor *cryptor = [RSAESCryptor sharedCryptor];

    [cryptor loadPublicKey:pubKeyPath];
    NSData *encData = [cryptor encryptData:[textData dataUsingEncoding:NSUTF8StringEncoding]];
    
    [cryptor loadPrivateKey:priKeyPath password:password];
    NSData *decData = [cryptor decryptData:encData];
    NSString *decText = [[NSString alloc] initWithData:decData encoding:NSUTF8StringEncoding];

    STAssertTrue([decText isEqualToString:textData], @"testMain failed.");
}

@end
