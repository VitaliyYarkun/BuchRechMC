//
//  Question.h
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/26/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Realm/Realm.h>
#import "RealmString.h"
#import "Answer.h"

@interface Question : RLMObject

@property NSInteger bookingEntry;
@property NSInteger chapter;
@property NSString *content;
@property NSInteger correctAnswerId;
@property NSInteger fromPage;
@property NSInteger toPage;
@property NSString *hint;
@property NSInteger generalId;
@property RLMArray <Answer *><Answer> *possibleAnswers;

@property BOOL isRightAnswered;

@end

RLM_ARRAY_TYPE(Question)
