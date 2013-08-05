//
//  SoSContactDetailsVC.h
//  ISoS
//
//  Created by Ujwal Manjunath on 7/30/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <QuartzCore/QuartzCore.h>    

@interface SoSContactDetailsVC : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>


@property ABRecordRef *person;


@end
