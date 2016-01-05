//
//  CIOV2Client.m
//  CIOAPIClient
//
//  Created by Alex Pretzlav on 7/28/15.
//  Copyright (c) 2015 Context.io. All rights reserved.
//

#import "CIOV2Client.h"

NSString *const CIOV2APIBaseURLString = @"https://api.context.io/2.0/";

@implementation CIOV2Client

- (instancetype)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret {
    self = [self initWithConsumerKey:consumerKey
                      consumerSecret:consumerSecret
                               token:nil
                         tokenSecret:nil
                           accountID:nil];
    return self;
}

- (instancetype)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret token:(NSString *)token tokenSecret:(NSString *)tokenSecret accountID:(NSString *)accountID {
    self = [self initWithBaseURLString:CIOV2APIBaseURLString
                           consumerKey:consumerKey
                        consumerSecret:consumerSecret
                                 token:token
                           tokenSecret:tokenSecret
                             accountID:accountID];
    return self;
}

#pragma mark - Account

- (CIODictionaryRequest *)getAccount {
    return [self dictionaryRequestForPath:self.accountPath method:@"GET" params:nil];
}

- (CIODictionaryRequest *)updateAccountWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (firstName) {
        params[@"first_name"] = firstName;
    }
    if (lastName ) {
        params[@"last_name"] = lastName;
    }
    return [self dictionaryRequestForPath:self.accountPath method:@"PUT" params:params];
}

- (CIODictionaryRequest *)deleteAccount {
    return [self dictionaryRequestForPath:self.accountPath method:@"DELETE" params:nil];
}

#pragma mark Contacts

- (CIOContactsRequest *)getContacts {
    return [CIOContactsRequest requestWithPath:[self.accountPath stringByAppendingPathComponent:@"contacts"]
                                        method:@"GET"
                                    parameters:nil
                                        client:self];
}

- (CIODictionaryRequest *)getContactWithEmail:(NSString *)email {
    NSString *contactsURLPath = [self.accountPath stringByAppendingPathComponent:@"contacts"];
    return [self dictionaryRequestForPath:[contactsURLPath stringByAppendingPathComponent:email]
                                   method:@"GET"
                                   params:nil];
}

- (CIOArrayRequest *)getFilesForContactWithEmail:(NSString *)email{
    return [self arrayGetRequestWithAccountComponents:@[@"contacts", email, @"files"]];
}

- (CIOArrayRequest *)getMessagesForContactWithEmail:(NSString *)email {
    return [self arrayGetRequestWithAccountComponents:@[@"contacts", email, @"messages"]];
}

- (CIOArrayRequest *)getThreadsForContactWithEmail:(NSString *)email {
    return [self arrayGetRequestWithAccountComponents:@[@"contacts", email, @"threads"]];
}

#pragma mark - Email Addresses

- (CIOArrayRequest *)getEmailAddresses {
    return [self arrayGetRequestWithAccountComponents:@[@"email_addresses"]];
}

- (CIODictionaryRequest *)addEmailAddress:(NSString *)email {
    return [self dictionaryRequestForPath:[self.accountPath stringByAppendingPathComponent:@"email_addresses"]
                                   method:@"POST"
                                   params:@{@"email_address": email}];
}

- (CIODictionaryRequest *)updateEmailAddressWithEmail:(NSString *)email primary:(BOOL)primary {
    NSString *path = [NSString pathWithComponents:@[self.accountPath, @"email_addresses", email]];
    return [self dictionaryRequestForPath:path
                                   method:@"POST"
                                   params:@{@"primary": @(primary)}];
}

- (CIODictionaryRequest *)deleteEmailAddressWithEmail:(NSString *)email {

    NSString *emailAddressesURLPath = [self.accountPath stringByAppendingPathComponent:@"email_addresses"];

    return [self dictionaryRequestForPath:[emailAddressesURLPath stringByAppendingPathComponent:email]
                                   method:@"DELETE"
                                   params:nil];
}

#pragma mark - Files

- (CIOFilesRequest *)getFiles {
    return [CIOFilesRequest requestWithPath:[self.accountPath stringByAppendingPathComponent:@"files"]
                                     method:@"GET"
                                 parameters:nil
                                     client:self];
}

- (CIODictionaryRequest *)getDetailsOfFileWithID:(NSString *)fileID {
    NSString *path = [NSString pathWithComponents:@[self.accountPath, @"files", fileID]];
    return [self dictionaryRequestForPath:path
                                   method:@"GET"
                                   params:nil];
}

- (CIOArrayRequest *)getChangesForFileWithID:(NSString *)fileID {
    return [self arrayGetRequestWithAccountComponents:@[@"files", fileID, @"changes"]];
}

- (CIOStringRequest *)getContentsURLForFileWithID:(NSString *)fileID {

    NSString *requestPath = [NSString pathWithComponents:@[self.accountPath, @"files", fileID, @"content"]];
    return [CIOStringRequest requestWithPath:requestPath
                                      method:@"GET"
                                  parameters:@{@"as_link": @YES}
                                      client:self];
}

- (CIORequest *)downloadContentsOfFileWithID:(NSString *)fileID {

    NSString *path = [NSString pathWithComponents:@[self.accountPath, @"files", fileID, @"content"]];
    return [CIORequest requestWithPath:path method:@"GET" parameters:nil client:self];
}

- (CIOArrayRequest *)getRelatedForFileWithID:(NSString *)fileID {

    NSString *filesURLPath = [self.accountPath stringByAppendingPathComponent:@"files"];
    NSString *fileURLPath = [filesURLPath stringByAppendingPathComponent:fileID];

    return
    [self arrayRequestForPath:[fileURLPath stringByAppendingPathComponent:@"related"] method:@"GET" params:nil];
}

- (CIOArrayRequest *)getRevisionsForFileWithID:(NSString *)fileID {

    NSString *filesURLPath = [self.accountPath stringByAppendingPathComponent:@"files"];
    NSString *fileURLPath = [filesURLPath stringByAppendingPathComponent:fileID];

    return [self arrayRequestForPath:[fileURLPath stringByAppendingPathComponent:@"revisions"]
                              method:@"GET"
                              params:nil];
}

#pragma mark - Messages

- (NSString *)pathForMessageID:(nullable NSString *)messageID {
    if (messageID) {
        return [NSString pathWithComponents:@[self.accountPath, @"messages", messageID]];
    } else {
        return [self.accountPath stringByAppendingPathComponent:@"messages"];
    }
}

- (CIOMessagesRequest *)getMessages {
    return [CIOMessagesRequest requestWithPath:[self pathForMessageID:nil]
                                        method:@"GET"
                                    parameters:nil
                                        client:self];
}

- (CIOMessageRequest *)getMessageWithID:(NSString *)messageID {
    return [CIOMessageRequest requestWithPath:[self pathForMessageID:messageID]
                                       method:@"GET"
                                   parameters:nil
                                       client:self];
}

- (CIOMessageUpdateRequest *)updateMessageWithID:(NSString *)messageID
                               destinationFolder:(NSString *)destinationFolder {
    return [CIOMessageUpdateRequest requestWithPath:[self pathForMessageID:messageID]
                                             method:@"POST"
                                         parameters:@{@"dst_folder": destinationFolder}
                                             client:self];
}

- (CIODictionaryRequest *)deleteMessageWithID:(NSString *)messageID {
    return [self dictionaryRequestForPath:[self pathForMessageID:messageID]
                                   method:@"DELETE"
                                   params:nil];
}

- (CIOArrayRequest *)getBodyForMessageWithID:(NSString *)messageID type:(nullable NSString *)type {
    NSDictionary *params = nil;
    if (type) {
        params = @{@"type": type};
    }
    return [self arrayRequestForPath:[[self pathForMessageID:messageID] stringByAppendingPathComponent:@"body"]
                              method:@"GET"
                              params:params];
}

#pragma mark Messages/Flags

- (CIODictionaryRequest *)getFlagsForMessageWithID:(NSString *)messageID {
    return [self dictionaryRequestForPath:[[self pathForMessageID:messageID] stringByAppendingPathComponent:@"flags"]
                                   method:@"GET"
                                   params:nil];
}

- (CIODictionaryRequest *)updateFlagsForMessageWithID:(NSString *)messageID flags:(CIOMessageFlags *)flags {
    return [self dictionaryRequestForPath:[[self pathForMessageID:messageID] stringByAppendingPathComponent:@"flags"]
                                   method:@"POST"
                                   params:[flags asDictionary]];
}

#pragma mark Messages/Folders

- (CIOArrayRequest *)getFoldersForMessageWithID:(NSString *)messageID {
    return [self arrayRequestForPath:[[self pathForMessageID:messageID] stringByAppendingPathComponent:@"folders"]
                              method:@"GET"
                              params:nil];
}

- (CIODictionaryRequest *)updateFoldersForMessageWithID:(NSString *)messageID addToFolder:(nullable NSString *)addFolder removeFromFolder:(nullable NSString *)removeFolder {
    NSString *path = [[self pathForMessageID:messageID] stringByAppendingPathComponent:@"folders"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (addFolder) {
        params[@"add"] = addFolder;
    }
    if (removeFolder) {
        params[@"remove"] = removeFolder;
    }
    return [self dictionaryRequestForPath:path
                                   method:@"POST"
                                   params:params];
}

- (CIODictionaryRequest *)setFoldersForMessageWithID:(NSString *)messageID folderNames:(NSArray *)folderNames symbolicFolderNames:(NSArray *)symbolicFolderNames {

    NSString *path = [[self pathForMessageID:messageID] stringByAppendingPathComponent:@"folders"];
    CIODictionaryRequest *request = [self dictionaryRequestForPath:path method:@"PUT" params:nil];
    NSMutableArray *requestBody = [NSMutableArray array];
    for (NSString *name in folderNames) {
        [requestBody addObject:@{@"name": name}];
    }
    for (NSString *symbolicName in symbolicFolderNames) {
        [requestBody addObject:@{@"symbolic_name": symbolicName}];
    }
    request.requestBody = requestBody;
    return request;
}

#pragma mark Messages/Headers

- (CIODictionaryRequest *)getHeadersForMessageWithID:(NSString *)messageID {
    NSString *path = [[self pathForMessageID:messageID] stringByAppendingPathComponent:@"headers"];
    return [self dictionaryRequestForPath:path
                                   method:@"GET"
                                   params:nil];
}

- (CIOStringRequest *)getRawHeadersForMessageWithID:(NSString *)messageID {
    NSString *path = [[self pathForMessageID:messageID] stringByAppendingPathComponent:@"headers"];
    return [CIOStringRequest requestWithPath:path
                                      method:@"GET"
                                  parameters:@{@"raw": @YES}
                                      client:self];
}

#pragma mark Messages/Source

- (CIORequest *)getSourceForMessageWithID:(NSString *)messageID {
    NSString *requestPath = [[self pathForMessageID:messageID] stringByAppendingPathComponent:@"source"];
    return [CIORequest requestWithPath:requestPath method:@"GET" parameters:nil client:self];
}

#pragma mark Messages/Thread

- (CIOMessageThreadRequest *)getThreadForMessageWithID:(NSString *)messageID {
    return [CIOMessageThreadRequest requestWithPath:[[self pathForMessageID:messageID] stringByAppendingPathComponent:@"thread"]
                                             method:@"GET"
                                         parameters:nil
                                             client:self];
}

#pragma mark - Sources

- (CIOArrayRequest *)getSources {
    return [CIOSourcesRequest requestWithPath:[self.accountPath stringByAppendingPathComponent:@"sources"]
                                       method:@"GET"
                                   parameters:nil
                                       client:self];
}

- (CIODictionaryRequest *)createSourceWithEmail:(NSString *)email
                                         server:(NSString *)server
                                       username:(NSString *)username
                                         useSSL:(BOOL)useSSL
                                           port:(NSInteger)port
                                           type:(NSString *)type {

    NSDictionary *params = @{
                             @"email": email,
                             @"server": server,
                             @"username": username,
                             @"use_ssl": @(useSSL),
                             @"port": @(port),
                             @"type": type};

    return [CIOSourceCreateRequest requestWithPath:[self.accountPath stringByAppendingPathComponent:@"sources"]

                                            method:@"POST"
                                        parameters:params
                                            client:self];
}

- (CIODictionaryRequest *)getSourceWithLabel:(NSString *)sourceLabel {
    NSString *path = [NSString pathWithComponents:@[self.accountPath, @"sources", sourceLabel]];

    return [self dictionaryRequestForPath:path
                                   method:@"GET"
                                   params:nil];
}

- (CIOSourceModifyRequest *)updateSourceWithLabel:(NSString *)sourceLabel {

    NSString *path = [NSString pathWithComponents:@[self.accountPath, @"sources", sourceLabel]];
    return [CIOSourceModifyRequest requestWithPath:path
                                            method:@"POST"
                                        parameters:nil
                                            client:self];
}

- (CIODictionaryRequest *)deleteSourceWithLabel:(NSString *)sourceLabel {

    NSString *sourcesURLPath = [self.accountPath stringByAppendingPathComponent:@"sources"];

    return [self dictionaryRequestForPath:[sourcesURLPath stringByAppendingPathComponent:sourceLabel]
                                   method:@"DELETE"
                                   params:nil];
}

- (CIOArrayRequest *)getFoldersForSourceWithLabel:(NSString *)sourceLabel
                            includeExtendedCounts:(BOOL)includeExtendedCounts
                                          noCache:(BOOL)noCache {
    NSString *path = [NSString pathWithComponents:@[self.accountPath, @"sources", sourceLabel, @"folders"]];
    NSDictionary *params = @{@"include_extended_counts": @(includeExtendedCounts),
                             @"no_cache": @(noCache)};
    return [self arrayRequestForPath:path method:@"GET" params:params];
}

- (CIODictionaryRequest *)getFolderWithPath:(NSString *)folderPath
                                sourceLabel:(NSString *)sourceLabel
                      includeExtendedCounts:(BOOL)includeExtendedCounts
                                      delim:(nullable NSString *)delim {
    NSString *path = [NSString pathWithComponents:@[self.accountPath, @"sources", sourceLabel, @"folders", folderPath]];
    NSMutableDictionary *params = [@{@"include_extended_counts": @(includeExtendedCounts)} mutableCopy];
    if (delim) {
        params[@"delim"] = delim;
    }
    return [self dictionaryRequestForPath:path
                                   method:@"GET"
                                   params:params];
}

- (CIODictionaryRequest *)createFolderWithPath:(NSString *)folderPath
                                   sourceLabel:(NSString *)sourceLabel
                                         delim:(nullable NSString *)delim {

    NSString *foldersURLPath =
    [NSString pathWithComponents:@[self.accountPath, @"sources", sourceLabel, @"folders", folderPath]];
    NSDictionary *params = nil;
    if (delim) {
        params = @{@"delim": delim};
    }
    return [self dictionaryRequestForPath:foldersURLPath method:@"PUT" params:params];
}

- (CIODictionaryRequest *)deleteFolderWithPath:(NSString *)folderPath sourceLabel:(NSString *)sourceLabel {

    NSString *sourcesURLPath = [self.accountPath stringByAppendingPathComponent:@"sources"];
    NSString *sourceURLPath = [sourcesURLPath stringByAppendingPathComponent:sourceLabel];
    NSString *foldersURLPath = [sourceURLPath stringByAppendingPathComponent:@"folders"];

    return [self dictionaryRequestForPath:[foldersURLPath stringByAppendingPathComponent:folderPath]
                                   method:@"DELETE"
                                   params:nil];
}

- (CIODictionaryRequest *)expungeFolderWithPath:(NSString *)folderPath
                                    sourceLabel:(NSString *)sourceLabel {

    NSString *path = [NSString pathWithComponents:@[self.accountPath, @"sources", sourceLabel, @"folders", folderPath, @"expunge"]];
    return [self dictionaryRequestForPath:path
                                   method:@"POST"
                                   params:nil];
}
- (CIOFolderMessagesRequest *)getMessagesForFolderWithPath:(NSString *)folderPath
                                               sourceLabel:(NSString *)sourceLabel {

    NSString *path = [NSString pathWithComponents:@[self.accountPath,
                                                    @"sources", sourceLabel, @"folders", folderPath, @"messages"]];
    return [CIOFolderMessagesRequest requestWithPath:path
                                              method:@"GET"
                                          parameters:nil
                                              client:self];
}

- (CIODictionaryRequest *)getSyncStatusForSourceWithLabel:(NSString *)sourceLabel {

    NSString *sourcesURLPath = [self.accountPath stringByAppendingPathComponent:@"sources"];
    NSString *sourceURLPath = [sourcesURLPath stringByAppendingPathComponent:sourceLabel];

    return [self dictionaryRequestForPath:[sourceURLPath stringByAppendingPathComponent:@"sync"]
                                   method:@"GET"
                                   params:nil];
}

- (CIODictionaryRequest *)forceSyncForSourceWithLabel:(NSString *)sourceLabel {

    NSString *sourcesURLPath = [self.accountPath stringByAppendingPathComponent:@"sources"];
    NSString *sourceURLPath = [sourcesURLPath stringByAppendingPathComponent:sourceLabel];

    return [self dictionaryRequestForPath:[sourceURLPath stringByAppendingPathComponent:@"sync"]
                                   method:@"POST"
                                   params:nil];
}

#pragma mark Sync

- (CIODictionaryRequest *)getSyncStatusForAllSources {
    return [self dictionaryRequestForPath:[self.accountPath stringByAppendingPathComponent:@"sync"]
                                   method:@"GET"
                                   params:nil];
}

- (CIODictionaryRequest *)forceSyncForAllSources {
    return [self dictionaryRequestForPath:[self.accountPath stringByAppendingPathComponent:@"sync"]
                                   method:@"POST"
                                   params:nil];
}


#pragma mark - Threads

- (CIOThreadsRequest *)getThreads {
    return [CIOThreadsRequest requestWithPath:[self.accountPath stringByAppendingPathComponent:@"threads"]
                                       method:@"GET"
                                   parameters:nil
                                       client:self];
}

- (CIOThreadRequest *)getThreadWithID:(NSString *)threadID {

    NSString *path = [NSString pathWithComponents:@[self.accountPath, @"threads", threadID]];
    return [CIOThreadRequest requestWithPath:path method:@"GET" parameters:nil client:self];
}

- (CIODictionaryRequest * __nonnull)deleteThreadWithID:(NSString * __nonnull)threadID {

    NSString *path = [NSString pathWithComponents:@[self.accountPath, @"threads", threadID]];
    return [self dictionaryRequestForPath:path
                                   method:@"DELETE"
                                   params:nil];
}

- (CIODictionaryRequest * __nonnull)updateFoldersForThreadWithID:(NSString * __nonnull)threadID addToFolder:(nullable NSString *)addFolder removeFromFolder:(nullable NSString *)removeFolder {
    NSString *path = [NSString pathWithComponents:@[self.accountPath, @"threads", threadID, @"folders"]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (addFolder) {
        params[@"add"] = addFolder;
    }
    if (removeFolder) {
        params[@"remove"] = removeFolder;
    }
    return [self dictionaryRequestForPath:path
                                   method:@"POST"
                                   params:params];
}

- (CIODictionaryRequest *)setFoldersForThreadWithID:(NSString *)threadID folderNames:(NSArray *)folderNames symbolicFolderNames:(NSArray *)symbolicFolderNames {
    NSString *folderPath = [NSString pathWithComponents:@[self.accountPath, @"threads", threadID, @"folders"]];
    CIODictionaryRequest *request = [self dictionaryRequestForPath:folderPath method:@"PUT" params:nil];
    NSMutableArray *requestBody = [NSMutableArray array];
    if (folderNames) {
        [requestBody addObject:@{@"name": folderNames}];
    }
    if (symbolicFolderNames) {
        [requestBody addObject:@{@"symbolic_name": symbolicFolderNames}];
    }
    request.requestBody = requestBody;
    return request;
}

#pragma mark - Discovery

- (CIODictionaryRequest * __nonnull)getSettingsForSourceType:(NSString * __nonnull)sourceType email:(NSString * __nonnull)email {
    return [CIODictionaryRequest requestWithPath:@"discovery"
                                          method:@"GET"
                                      parameters:@{@"source_type": sourceType, @"email": email}
                                          client:self];
}


@end
