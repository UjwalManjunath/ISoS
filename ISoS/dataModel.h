//
//  dataModel.h
//  ISoS
//
//  Created by Ujwal Manjunath on 8/8/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataModel : NSObject



-(NSString *)keyAtIndex:(NSUInteger)index;
-(NSDictionary *)getContacts;

-(id)getValueForKeyatIndex:(NSUInteger)index;

-(NSArray *)allKeys;



-(void) pushObject:(id)object key:(NSString *)key;
@end
