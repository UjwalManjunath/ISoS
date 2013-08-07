//
//  SoSviewContactCell.h
//  ISoS
//
//  Created by Ujwal Manjunath on 7/30/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface SoSviewContactCell : UITableViewCell


@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property(nonatomic,strong) NSData* profilePictureData;
@end
