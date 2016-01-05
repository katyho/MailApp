//
//  Messages.h
//  MailApp
//
//  Created by Katy Ho on 12/25/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//
//  Message object with relevant fields

#import <Foundation/Foundation.h>

@interface Messages : NSObject

@property(strong, nonatomic) NSString *subject;
@property(strong, nonatomic) NSString *date;


+(NSArray *)messagesArrayForResponse:(NSArray *)response; 

@end
