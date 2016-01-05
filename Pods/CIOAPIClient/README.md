Build awesome things with email! We take the pain out of syncing email data with your app so you can focus on what makes your product great.

CIOAPIClient is an easy to use iOS and OS X library for communicating with the Context.IO 2.0 API. It is built upon [NSURLSession](https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSession_class/index.html) and provides convenient asynchronous block based methods for interacting with the API.

## Getting Started

* Sign up for a developer account at [Context.IO](http://context.io)
* [Submit a request](http://support.context.io/hc/en-us/requests/new) for a 3-legged OAuth Token. This library only supports 3-legged tokens to ensure end-users of your application can only access their own account
* [Download CIOAPIClient](https://github.com/contextio/contextio-ios) and check out the included iOS example app. It is also available as a [CocoaPod](http://cocoapods.org/) to make it even easier to add to your project
* View the full [Context.IO API documentation](http://context.io/docs/2.0) to better familiarize yourself with the API

## Using [CocoaPods](https://cocoapods.org)

To use `CIOAPIClient` in your project:

* If you don't have a podfile, run `pod init` to create one
* Add the following to your `Podfile`:<br>

```ruby
pod 'CIOAPIClient', '~> 1.0'
```

* Run `pod install` to install `CIOAPIClient` and its dependencies, then make sure to open the `.xcworkspace` file instead of `.xcodeproj` if you weren't using it already

[podfile]: https://guides.cocoapods.org/using/the-podfile.html

## Building the Example App

After cloning the git repository, make sure to install cocoapods used by the example app:

* `cd <repository path>/Example`
* `pod install`
* `open "Context.IO iOS Example App.xcworkspace"`

To run the example application, you will need to insert your Context.IO consumer key and secret in `CIOAppDelegate.m`.

## Exploring the API in a Playground

There is an Xcode Playground (requires Xcode 7) included in the main library `xcworkspace`. Playgrounds with library dependencies are slightly finicky, follow these steps to get it working:

* `git clone https://github.com/contextio/contextio-ios.git`
* `cd contextio-ios`
* `pod install`
* `open CIOAPIClient.xcworkspace`
* Select the `CIOAPIClient Mac` Scheme in the Xcode scheme selection dropdown (it should have a dynamic framework yellow toolbox icon)
* Build the scheme (⌘B)
* Select `CIOPlayground.playground` from the `CIOAPIClient` project in the Project navigator left sidebar
* Add your consumer key and consumer secret to the line
```swift
let let liteSession = CIOLiteClient(consumerKey: "", consumerSecret: "")
```
* At this point the playground will execute and an authentication WebView will appear in the bottom left corner of your screen
* Authorize an email account using the Context.IO auth flow in the WebView
    - The first time the code executes after authentication it may fail. Choose `Execute Playground` from the `Editor` menu to run it again.
* Add any code you wish to try to the `authenticator.withAuthentication{ session in` block in the playground
* Subsequent launches may ask your permission to access Keychain, this is because the library saves your Context.IO authorization credentials to the local mac keychain.

## Example Usage

Use `CIOV2Client` to construct and execute signed [`NSURLRequests`][nsurl] against the [Context.IO 2.0 API](https://context.io/docs/2.0).
Use `CIOLiteClient` for the [Context.IO Lite API](https://context.io/docs/lite). The following examples use Swift for the Lite API and Objective-C for the 2.0 API for illustration, both languages work fine for both APIs.

[nsurl]: https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSURLRequest_Class/index.html

### Beginning an API Session

Initialize `CIOV2Client` with your API key consumer key and consumer secret:

``` objective-c
CIOV2Client *session = [[CIOV2Client alloc] initWithConsumerKey:@"your-consumer-key"
                                                 consumerSecret:@"your-consumer-secret"];
```

Or use `CIOLiteClient` in the same way for the Lite API:

```swift
let liteSession = CIOLiteClient(consumerKey: "your-consumer-key",
                                consumerSecret: "your-consumer-secret")
```

### Authentication

`CIO*Client` uses [Connect Tokens][ct] to authorize individual user's email accounts. Please see the example application for an overview of the authentication process. Feel free to re-use or subclass [`CIOAuthViewController`][cioauth] in your own project - it takes care of the details of authentication and should work out of the box for most purposes.

[cioauth]: https://github.com/contextio/contextio-ios/blob/master/Example/Classes/Controllers/CIOAuthViewController.m
[ct]: https://context.io/docs/2.0/connect_tokens

## Context.IO Lite API Examples

### [List Folders For an Account](https://context.io/docs/lite/users/email_accounts/folders)

```swift
session.getFoldersForAccountWithLabel(nil, includeNamesOnly: false)
    .executeWithSuccess({ folders in
        print(folders)
    },
    failure: { error in
        print(error)
})
```

### [Retrieve Messages In a Folder](https://context.io/docs/lite/users/email_accounts/folders/messages)


```swift
session.getMessagesForFolderWithPath("INBOX", accountLabel: nil)
    .executeWithSuccess({ messages in
        print(messages)
    },
    failure: { error in
        print("Error: \(error)")
})
```

### [Retrieve a Single Message By ID](https://context.io/docs/lite/users/email_accounts/folders/messages#id-get)

Fetch detailed attributes of a single message based on its `message_id` property

```swift
let request = session.requestForMessageWithID(
    "<CAPEPyeZhF_P6Hvn-MTYNkzaiL0EBym1G+oir31tR_DzP6KB3Mw@mail.gmail.com>",
    inFolder: "INBOX", accountLabel: nil, delimiter: nil)
request.include_body = true
request.include_flags = true
request.executeWithSuccess({ message in
        print(message)
    }, failure: { error in
        print(error)
})
```

### [Retrieve Headers for a Message](https://context.io/docs/lite/users/email_accounts/folders/messages/headers)

```swift
let request = session.requestForMessageWithID(
    "<CAPEPyeZhF_P6Hvn-MTYNkzaiL0EBym1G+oir31tR_DzP6KB3Mw@mail.gmail.com>",
    inFolder: "INBOX", accountLabel: nil, delimiter: nil)
request.getHeaders().executeWithSuccess({ headers in
        print(headers)
    }, failure: { error in
        print(error)
})
```

## Context.IO 2.0 API Examples

### [Retrieve Messages](https://context.io/docs/2.0/accounts/messages)

Get messages in Inbox with an attachment and subject matching a regular expression:

``` objective-c
CIOMessagesRequest *request = [session getMessages];
request.subject = @"/.*presentation.*/i";
request.file_name = @"*";
request.folder = @"Inbox";
[request executeWithSuccess:^(NSArray *responseArray) {
    NSLog(@"%@", responseArray);
} failure:^(NSError *error) {
    NSLog(@"error getting messages: %@", error);
}];

```

### [Add a Message to an Existing Folder/Label](https://context.io/docs/2.0/accounts/messages/folders)

``` objective-c
[[session updateFoldersForMessageWithID:message[@"message_id"]
                            addToFolder:@"Test Folder"
                       removeFromFolder:nil]
 executeWithSuccess:^(NSDictionary *response) {
     NSLog(@"Response: %@", response);
 } failure:^(NSError *error) {
     NSLog(@"error moving message: %@", error);
 }];
```

### [List Folders/Labels For An Account](https://context.io/docs/2.0/accounts/sources/folders#get)
```objective-c
// 0 is an alias for the first source of an account
[[session getFoldersForSourceWithLabel:@"0" includeExtendedCounts:NO noCache:NO]
 executeWithSuccess:^void(NSArray *folders) {
     NSLog(@"Folders: %@", folders);
 } failure:^void(NSError *error) {
     NSLog(@"Error getting folders: %@", error);
 }];
```

### [Download A Message Attachment](https://context.io/docs/2.0/accounts/files/content)

``` objective-c
NSDictionary *file = [message[@"files"] firstObject];
CIODownloadRequest *downloadRequest = [session downloadContentsOfFileWithID:file[@"file_id"]];
// Save file with attachment's filename in NSDocumentDirectory
NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                              inDomains:NSUserDomainMask] lastObject];
NSURL *fileURL = [documentsURL URLByAppendingPathComponent:file[@"file_name"]];
[session downloadRequest:downloadRequest
               toFileURL:fileURL
                 success:^{
                     NSLog(@"File downloaded: %@", [fileURL path]);
                 }
                 failure:^(NSError *error) {
                     NSLog(@"Download error: %@", error);
                 }
                progress:^(int64_t bytesRead, int64_t totalBytesRead, int64_t totalBytesExpected){
                    NSLog(@"Download progress: %0.2f%%",
                          ((double)totalBytesExpected / (double)totalBytesRead) * 100);
                }];

```

## Requirements

`CIOAPIClient` requires either iOS 7.0 and above or Mac OS 10.9 or above.

## Acknowledgements

Thanks to [Kevin Lord](https://github.com/lordkev) who wrote the original version of this library, [Sam Soffes](https://github.com/soffes) for [sskeychain](https://github.com/soffes/sskeychain), and TweetDeck for [TDOAuth](https://github.com/tweetdeck/tdoauth) which is used for the OAuth signature generation in CIOAPIClient.

## License

`CIOAPIClient` is licensed under the MIT License. See the `LICENSE` file for details.
