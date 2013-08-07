//
//  SoSviewContactCell.m
//  ISoS
//
//  Created by Ujwal Manjunath on 7/30/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "SoSviewContactCell.h"
@interface SoSviewContactCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;



@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;


@end
@implementation SoSviewContactCell

-(void)setFirstName:(NSString *)firstName
{
    _firstName = firstName;
    self.firstNameLabel.text = firstName;
}

-(void)setLastName:(NSString *)lastName
{
    _lastName = lastName;
    self.lastNameLabel.text = lastName;
}

-(void)setProfilePictureData:(NSData *)profilePictureData
{
    _profilePictureData = profilePictureData   ;
    self.profileImageView.image = [UIImage imageWithData:profilePictureData];
}

-(void)setProfileImageView:(UIImageView *)profileImageView
{
    _profileImageView = profileImageView;
    CALayer *pL = [profileImageView layer];
    [pL setMasksToBounds:YES];
    [pL setCornerRadius:10.0];
}

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

@end
