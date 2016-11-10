//
//  ServerManager.h
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/20/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Global.h"

typedef NS_ENUM(NSInteger, RealmDataSaveOption)
{
    kSaveAllQuestionsOption = 1000,
    kSaveAllTopicsOption,
    kSaveAllLecturesOption
};

@interface ServerManager : NSObject

@property (strong, nonatomic) RLMRealm *realm;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *password;


-(void) httpRequestWithUrl:(NSURL *) requestUrl
            withHTTPMethod:(NSString *) requestMethod;

-(void) sendLoginRequestWithUserName:(NSString *) userName
                        withPassword:(NSString *) password;
-(void) getAllQuestions;
-(void) getAllLectures;
-(void) getAllTopics;
-(void) getUserByFirstName:(NSString *) firstName andLastName:(NSString *) lastName;

+(instancetype) sharedManager;

@end
