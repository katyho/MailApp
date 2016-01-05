//
//  Contacts.m
//  MailApp
//
//  Created by Katy Ho on 12/24/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//
//  Contact object with relevant fields

#import "Contacts.h"

@implementation Contacts

//  Initialize fields of Contact from the dictionary object for each contact
-(id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _name = dict[@"name"];
        _email = dict[@"email"];
        NSInteger sentCount = [dict[@"sent_count"] integerValue];
        NSInteger receivedCount = [dict[@"received_count"] integerValue];
        if (sentCount == 0) {
            _statistic = 0;
        } else {
            _statistic = (float)receivedCount/(float)sentCount;
        }
    }
    return self;
}

//  Return an array of Contact objects from the response returned by
//  getContacts method of the ContextIO API. 
+ (NSArray *)contactsArrayForResponse:(NSDictionary *)response {
    NSMutableArray *contactsArray = [NSMutableArray array];
    NSArray *contacts = [response valueForKey:@"matches"];
    for (NSDictionary *dict in contacts) {
        Contacts *c = [[Contacts alloc] initWithDictionary:dict];
        [contactsArray addObject:c];
    }
    return contactsArray;
}
@end
