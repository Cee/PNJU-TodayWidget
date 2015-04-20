//
//  NetworkManager.h
//  PNJU
//
//  Created by Cee on 17/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ConnectedStatus) {
    ConnectedStatusSuccess,
    ConnectedStatusFail,
    ConnectedStatusError,
};

@interface NetworkManager : NSObject

+ (instancetype)sharedNetworkManager;
- (NSString *)loginWithUsername:(NSString *)username password:(NSString *)password;
- (void)logout;
- (ConnectedStatus)checkOnline;
- (id)userInfo;

@end
