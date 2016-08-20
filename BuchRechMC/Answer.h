//
//  Answer.h
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/21/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Realm/Realm.h>

@interface Answer : RLMObject

@property NSString *content;
@property NSInteger answerId;
@property NSInteger generalId;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Answer>
RLM_ARRAY_TYPE(Answer)
