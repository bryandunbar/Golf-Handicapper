//
//  GHScore.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/16/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SSManagedObject.h"
@class GHCourse, GHPlayer;

@interface GHScore : SSManagedObject

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) GHCourse *course;
@property (nonatomic, retain) GHPlayer *player;


@property (nonatomic,readonly) double differential;

@end