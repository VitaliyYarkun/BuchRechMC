//
//  BookViewController.h
//  BuchRechMC
//
//  Created by Vitaliy Yarkun on 4/6/16.
//  Copyright © 2016 Vitaliy Yarkun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kGL = 1000,
    kBF,
    kBF1,
    kBF2,
    kJA,
    kBL,
    kGV,
    kBB
} bookSelection;

@interface BookViewController : UIViewController

@property (assign, nonatomic) NSInteger cellTag;
@property (strong, nonatomic) NSString *bookName;

@end
