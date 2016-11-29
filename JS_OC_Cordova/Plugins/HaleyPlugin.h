//
//  HaleyPlugin.h
//  HelloCordova
//
//  Created by Harvey on 16/9/28.
//
//

#import "HTMICDV.h"

@interface HaleyPlugin : HTMICDVPlugin

- (void)scan:(HTMICDVInvokedUrlCommand *)command;

- (void)location:(HTMICDVInvokedUrlCommand *)command;

- (void)pay:(HTMICDVInvokedUrlCommand *)command;

- (void)share:(HTMICDVInvokedUrlCommand *)command;

- (void)changeColor:(HTMICDVInvokedUrlCommand *)command;

- (void)shake:(HTMICDVInvokedUrlCommand *)command;

- (void)playSound:(HTMICDVInvokedUrlCommand *)command;

@end
