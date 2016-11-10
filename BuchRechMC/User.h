//
//  User.h
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 11/11/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <Realm/Realm.h>

@interface User : RLMObject

@property NSString *name;
@property NSString *password;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<User>
RLM_ARRAY_TYPE(User)
