//
//  SoSCustomContactDetailCell.h
//  ISoS
//
//  Created by Ujwal Manjunath on 8/5/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoSCustomContactDetailCell : UITableViewCell

@property (nonatomic,strong) NSString *titleLabelText;

@property (nonatomic,strong) NSString *detailTextFieldText;

@property (nonatomic,strong) NSString *detailTextFieldPlaceHolder;

@property (weak, nonatomic) IBOutlet UITextField *detailText;
@end
