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

#import <Foundation/Foundation.h>
#import "HTMICDVAvailability.h"

typedef enum {
    HTMICDVCommandStatus_NO_RESULT = 0,
    HTMICDVCommandStatus_OK,
    HTMICDVCommandStatus_CLASS_NOT_FOUND_EXCEPTION,
    HTMICDVCommandStatus_ILLEGAL_ACCESS_EXCEPTION,
    HTMICDVCommandStatus_INSTANTIATION_EXCEPTION,
    HTMICDVCommandStatus_MALFORMED_URL_EXCEPTION,
    HTMICDVCommandStatus_IO_EXCEPTION,
    HTMICDVCommandStatus_INVALID_ACTION,
    HTMICDVCommandStatus_JSON_EXCEPTION,
    HTMICDVCommandStatus_ERROR
} HTMICDVCommandStatus;

@interface HTMICDVPluginResult : NSObject {}

@property (nonatomic, strong, readonly) NSNumber* status;
@property (nonatomic, strong, readonly) id message;
@property (nonatomic, strong)           NSNumber* keepCallback;
// This property can be used to scope the lifetime of another object. For example,
// Use it to store the associated NSData when `message` is created using initWithBytesNoCopy.
@property (nonatomic, strong) id associatedObject;

- (HTMICDVPluginResult*)init;
+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal;
+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsString:(NSString*)theMessage;
+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsArray:(NSArray*)theMessage;
+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsInt:(int)theMessage;
+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsNSInteger:(NSInteger)theMessage;
+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsNSUInteger:(NSUInteger)theMessage;
+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsDouble:(double)theMessage;
+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsBool:(BOOL)theMessage;
+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsDictionary:(NSDictionary*)theMessage;
+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsArrayBuffer:(NSData*)theMessage;
+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageAsMultipart:(NSArray*)theMessages;
+ (HTMICDVPluginResult*)resultWithStatus:(HTMICDVCommandStatus)statusOrdinal messageToErrorObject:(int)errorCode;

+ (void)setVerbose:(BOOL)verbose;
+ (BOOL)isVerbose;

- (void)setKeepCallbackAsBool:(BOOL)bKeepCallback;

- (NSString*)argumentsAsJSON;

@end
