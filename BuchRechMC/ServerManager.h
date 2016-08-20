//
//  ServerManager.h
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/20/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

-(void) httpRequestWithUrl:(NSURL *) requestUrl
  withAllowedCharactersSet:(NSSet *) requestSet
            withHTTPMethod:(NSString *) requestMethod;

-(void) getAllQuestions;


+(instancetype) sharedManager;

@end
