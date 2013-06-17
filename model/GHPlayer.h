//
//  GHPlayer.h
//  Golf Handicapper
//
//  Created by Bryan Dunbar on 6/15/13.
//  Copyright (c) 2013 iPwn Technologies LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SSManagedObject.h"

@class GHLeague;

@interface GHPlayer : SSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSDecimalNumber * handicapIndex;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *leagues;

/** Transient **/
@property (nonatomic, retain) NSNumber * score;

@end

@interface GHPlayer (CoreDataGeneratedAccessors)

- (void)addLeaguesObject:(GHLeague *)value;
- (void)removeLeaguesObject:(GHLeague *)value;
- (void)addLeagues:(NSSet *)values;
- (void)removeLeagues:(NSSet *)values;

@end
