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
    NSURL *url = [[NSURL alloc] initWithString:@"http://p.nju.edu.cn/portal_io/login"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *actionString = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    NSData *data = [actionString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseStr);
    return responseStr;
}

- (void)logout
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://p.nju.edu.cn/portal_io/logout"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseStr);
}

- (ConnectedStatus)checkOnline
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://p.nju.edu.cn/portal_io/proxy/userinfo"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        return ConnectedStatusError;
    }
    NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseStr);
    id json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    NSUInteger replyCodeString = [[json objectForKey:@"reply_code"] integerValue];
    if (replyCodeString == 3010101) {
        return ConnectedStatusSuccess;
    } else {
        return ConnectedStatusFail;
    }
}

- (id)userInfo
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://p.nju.edu.cn/portal_io/proxy/userinfo"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    json = [json objectForKey:@"results"];
    return json;
}

@end
