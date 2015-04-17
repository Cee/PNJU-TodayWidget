//
//  NetworkManager.m
//  PNJU
//
//  Created by Cee on 17/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

+ (instancetype)sharedNetworkManager
{
    static NetworkManager *networkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[NetworkManager alloc] init];
    });
    
    return networkManager;
}

- (NSString *)loginWithUsername:(NSString *)username password:(NSString *)password
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://p.nju.edu.cn/portal/portal_io.do"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *actionString = [NSString stringWithFormat:@"action=login&username=%@&password=%@", username, password];
    NSData *data = [actionString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseStr);
    return responseStr;
}

- (void)logout
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://p.nju.edu.cn/portal/portal_io.do"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *actionString = @"action=logout";
    NSData *data = [actionString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseStr);
}

@end
