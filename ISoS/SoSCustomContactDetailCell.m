//
//  SoSCustomContactDetailCell.m
//  ISoS
//
//  Created by Ujwal Manjunath on 8/5/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "SoSCustomContactDetailCell.h"

@interface SoSCustomContactDetailCell()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end

@implementation SoSCustomContactDetailCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setDetailTextFieldPlaceHolder:(NSString *)detailTextFieldPlaceHolder
{
    _detailTextFieldPlaceHolder = detailTextFieldPlaceHolder    ;
    self.detailText.placeholder = detailTextFieldPlaceHolder    ;
}

-(void) setDetailTextFieldText:(NSString *)detailTextFieldText
{
    _detailTextFieldText = detailTextFieldText  ;
    self.detailText.text = detailTextFieldText;
}

-(void) setTitleLabelText:(NSString *)titleLabelText
{
    _titleLabelText = titleLabelText;
    
    self.titleLabel.text = titleLabelText   ;
    
}





@end
