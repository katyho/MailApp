//
//  Messages.m
//  MailApp
//
//  Created by Katy Ho on 12/25/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//
//  Message object with relevant fields

#import "Messages.h"

@implementation Messages

//  Initialize fields of Message from the dictionary object for each message
-(in)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        NSLog(@"dict %@", dict);
        NSTimeInterval d = [[dict valueForKey:@"date"] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:d];
        _date = [self stringFromDate:date];
        _subject = [dict valueForKey:@"subject"];
        
    }
    return self;
}

//  Convert NSDate object into a string with format "dd-MM-yyyy"
- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy 'at' HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
    
}

//  Return an array of Message objects from the response returned by
//  the getContacts method of the ContextIO API. 
+(NSArray *)messagesArrayForResponse:(NSArray *)response {
    NSMutableArray *messageArray = [NSMutableArray array];
    for (NSDictionary *dict in response) {
        Messages *m = [[Messages alloc] initWithDictionary:dict];
        [messageArray addObject:m];
    }
    return messageArray;
}

@end
