//
//  NSString.m
//  MailApp
//
//  Created by Katy Ho on 12/24/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

+ (BOOL)isNullOrEmpty:(NSString *)value {
    return value == nil || value.length == 0;
}

@end
