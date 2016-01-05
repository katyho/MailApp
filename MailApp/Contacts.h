//
//  Contacts.h
//  MailApp
//
//  Created by Katy Ho on 12/24/15.
//  Copyright © 2015 KatyHo. All rights reserved.
//

// Contact object with relevant fields

#import <Foundation/Foundation.h>

@interface Contacts : NSObject

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *email;
@property(nonatomic) float statistic;

-(id)initWithDictionary:(NSDictionary*)dict;

+ (NSArray *)contactsArrayForResponse:(NSDictionary *)response;

@end
