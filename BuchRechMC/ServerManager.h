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
    kSaveAllTopicsOption,
    kSaveAllLecturesOption
};

@interface ServerManager : NSObject

@property (strong, nonatomic) RLMRealm *realm;

-(void) httpRequestWithUrl:(NSURL *) requestUrl
            withHTTPMethod:(NSString *) requestMethod;

-(BOOL) sendLoginRequestWithUserName:(NSString *) userName
                        withPassword:(NSString *) password;
-(void) getAllQuestions;
-(void) getAllLectures;
-(void) getAllTopics;
-(void) getAllUsers;

+(instancetype) sharedManager;

@end
