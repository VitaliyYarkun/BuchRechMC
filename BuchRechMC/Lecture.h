//
//  Lecture.h
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/26/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Realm/Realm.h>

@interface Lecture : RLMObject

@property NSInteger lectureId;
@property NSString *name;
@property NSInteger startChapter;
@property NSInteger endChapter;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Lecture>
RLM_ARRAY_TYPE(Lecture)
