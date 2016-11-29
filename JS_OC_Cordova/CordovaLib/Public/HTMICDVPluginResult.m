/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "HTMICDVPluginResult.h"
#import "HTMICDVJSON_private.h"
#import "HTMICDVDebug.h"

@interface HTMICDVPluginResult ()

- (HTMICDVPluginResult*)initWithStatus:(HTMICDVCommandStatus)statusOrdinal message:(id)theMessage;

@end

@implementation HTMICDVPluginResult
@synthesize status, message, keepCallback, associatedObject;

static NSArray* org_apache_cordova_CommandStatusMsgs;

id HTMICDVmessageFromArrayBuffer(NSData* data)
{
    return @{
               @"HTMICDVType" : @"ArrayBuffer",
               @"data" :[data base64EncodedStringWithOptions:0]
    };
}

id HTMICDVmassageMessage(id message)
{
    if ([message isKindOfClass:[NSData class]]) {
        return HTMICDVmessageFromArrayBuffer(message);
    }
    return message;
}

id HTMICDVmessageFromMultipart(NSArray* theMessages)
{
    NSMutableArray* messages = [NSMutableArray arrayWithArray:theMessages];

    for (NSUInteger i = 0; i < messages.count; ++i) {
        [messages replaceObjectAtIndex:i withObject:HTMICDVmassageMessage([messages objectAtIndex:i])];
    }

    return @{
               @"HTMICDVType" : @"MultiPart",
               @"messages" : messages
    };
}

+ (void)initialize
{
    org_apache_cordova_CommandStatusMsgs = [[NSArray alloc] initWithObjects:@"No result",
        @"OK",
        @"Class not found",
        @"Illegal access",
        @"Instantiation error",
        @"Malformed url",
        @"IO error",
        @"Invalid action",
        @"JSON error",
        @"Error",
        nil];
}

- (HTMICDVPluginResult*)init
{
    return [self initWithStatus:HTMICDVCommandStatus_NO_RESULT message:nil];
}

- (HTMICDVPluginResult*)initWithStatus:(HTMICDVCommandStatus)statusOrdinal message:(id)theMessage
{
    self = [super init];
    if (self) {
        status = [NSNumber numberWithInt:statusOrdinal];
        message = theMessage;
        keepCallback = [NSNumber numberWithBool:NO];
    }
    return self;
}

+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal
{
    return [[self alloc] initWithStatus:statusOrdinal message:nil];
}

+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsString:(NSString*)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:theMessage];
}

+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsArray:(NSArray*)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:theMessage];
}

+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsInt:(int)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:[NSNumber numberWithInt:theMessage]];
}

+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsNSInteger:(NSInteger)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:[NSNumber numberWithInteger:theMessage]];
}

+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsNSUInteger:(NSUInteger)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:[NSNumber numberWithUnsignedInteger:theMessage]];
}

+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsDouble:(double)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:[NSNumber numberWithDouble:theMessage]];
}

+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsBool:(BOOL)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:[NSNumber numberWithBool:theMessage]];
}

+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsDictionary:(NSDictionary*)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:theMessage];
}

+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsArrayBuffer:(NSData*)theMessage
{
    return [[self alloc] initWithStatus:statusOrdinal message:HTMICDVmessageFromArrayBuffer(theMessage)];
}

+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsMultipart:(NSArray*)theMessages
{
    return [[self alloc] initWithStatus:statusOrdinal message:HTMICDVmessageFromMultipart(theMessages)];
}

+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageToErrorObject:(int)errorCode
{
    NSDictionary* errDict = @{@"code" :[NSNumber numberWithInt:errorCode]};

    return [[self alloc] initWithStatus:statusOrdinal message:errDict];
}

- (void)setKeepCallbackAsBool:(BOOL)bKeepCallback
{
    [self setKeepCallback:[NSNumber numberWithBool:bKeepCallback]];
}

- (NSString*)argumentsAsJSON
{
    id arguments = (self.message == nil ? [NSNull null] : self.message);
    NSArray* argumentsWrappedInArray = [NSArray arrayWithObject:arguments];

    NSString* argumentsJSON = [argumentsWrappedInArray HTMICDV_JSONString];

    argumentsJSON = [argumentsJSON substringWithRange:NSMakeRange(1, [argumentsJSON length] - 2)];

    return argumentsJSON;
}

static BOOL gIsVerbose = NO;
+ (void)setVerbose:(BOOL)verbose
{
    gIsVerbose = verbose;
}

+ (BOOL)isVerbose
{
    return gIsVerbose;
}

@end
