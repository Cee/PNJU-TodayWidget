//
//  NetworkManager.h
//  PNJU
//
//  Created by Cee on 17/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (instancetype)sharedNetworkManager;
- (NSString *)loginWithUsername:(NSString *)username password:(NSString *)password;
- (void)logout;
- (BOOL)checkOnline;
- (id)userInfo;

@end
