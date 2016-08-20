//
//  RealmString.h
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 8/20/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Realm/Realm.h>

@interface RealmString : RLMObject

@property NSString *stringValue;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RealmString>
RLM_ARRAY_TYPE(RealmString)
