//
//  RESTAPI.h
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/16/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RESTAPI;

@protocol RESTAPIDelegate
- (void)getReceivedData:(NSMutableData *)data sender:(RESTAPI *)sender;
@end

@interface RESTAPI : NSObject

@property (weak, nonatomic) id  <RESTAPIDelegate> delegate;

- (void)httpRequest:(NSMutableURLRequest *)request;

@end