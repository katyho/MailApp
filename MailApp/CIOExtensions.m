//
//  CIOExtensions.m
//  MailApp
//
//  Created by Katy Ho on 12/24/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//
//  Extension to obtain OAuth authentication with the constants in the
//  Contants.h file 

#import "CIOExtensions.h"
#import "Constants.h"

@implementation CIOV2Client (Extensions)

+ (instancetype)sharedInstance {
    static CIOV2Client *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CIOV2Client alloc] initWithConsumerKey:kContextIOConsumerKey consumerSecret:kContextIOConsumerSecret token:kContextIOAuthToken tokenSecret:kContextIOAuthSecret accountID:kContextIOAccountID];
    });
    return instance;
}


@end
