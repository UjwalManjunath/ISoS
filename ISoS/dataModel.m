//
//  dataModel.m
//  ISoS
//
//  Created by Ujwal Manjunath on 8/8/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "dataModel.h"
@interface dataModel()

@property (nonatomic,strong) NSMutableDictionary *contacts;

@end

@implementation dataModel


-(NSMutableDictionary *)contacts
{
    
  
    if(!_contacts)
    {
        if([[self class] pullFromPlist] == nil)
            _contacts = [[NSMutableDictionary alloc]initWithDictionary:@{@"Family": @"null",@"Friends":@"null" }];
        else
            _contacts = [[self class]pullFromPlist];
    }
    return  _contacts;
}



-(void) pushObject:(id)object key:(NSString *)key{
    [self.contacts setObject:object forKey:key];
    [self pushToPlist];
    
}





-(NSArray *)allKeys
{
    return [self.contacts allKeys];
}

-(NSString *)keyAtIndex:(NSUInteger)index{
    return [[self.contacts allKeys] objectAtIndex: index];
}

-(NSDictionary *)getContacts{
    return [self.contacts copy];
}

-(id)getValueForKeyatIndex:(NSUInteger)index{
    return [self.contacts valueForKey:[[self.contacts allKeys] objectAtIndex:index] ];
}

-(void)pushToPlist
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[self.contacts copy] forKey:@"Contacts"];
    [def synchronize];
    
}

+(NSMutableDictionary   *)pullFromPlist
{
    return  [[[NSUserDefaults standardUserDefaults] objectForKey:@"Contacts"] mutableCopy];
}



@end
