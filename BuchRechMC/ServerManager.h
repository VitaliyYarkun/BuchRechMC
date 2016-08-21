//
//  ServerManager.h
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/20/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RealmDataSaveOption)
{
    kSaveAllQuestionsOption = 1000,
    kSaveAllTopicsOption
};

@interface ServerManager : NSObject

-(void) httpRequestWithUrl:(NSURL *) requestUrl
            withHTTPMethod:(NSString *) requestMethod;

-(void) getAllQuestions;
-(void) getAllLectures;
-(void) getAllTopics;

-(void) saveAllQuestionsToRealm;

+(instancetype) sharedManager;

@end
