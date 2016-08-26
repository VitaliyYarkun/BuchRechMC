//
//  ServerManager.h
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/20/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

typedef NS_ENUM(NSInteger, RealmDataSaveOption)
{
    kSaveAllQuestionsOption = 1000,
    kSaveAllTopicsOption
};

@interface ServerManager : NSObject{
    RLMRealm *_realm;
}

@property (strong, nonatomic) RLMRealm *realm;

-(void) httpRequestWithUrl:(NSURL *) requestUrl
            withHTTPMethod:(NSString *) requestMethod;

-(void) getAllQuestions;
-(void) getAllLectures;
-(void) getAllTopics;

+(instancetype) sharedManager;

@end
