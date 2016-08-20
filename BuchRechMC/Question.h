//
//  Question.h
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/26/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Realm/Realm.h>
#import "RealmString.h"

@interface Question : RLMObject

@property NSInteger bookingEntry;
@property NSInteger chapter;
@property NSString *questionContent;
@property NSInteger correctAnswerId;
@property NSInteger questionFromPage;
@property NSInteger questionToPage;
@property NSString *hint;
@property NSInteger questionID;
@property RLMArray <RealmString *><RealmString> *possibleAnswers;

@property BOOL isRightAnswered;

@end

RLM_ARRAY_TYPE(Question)
