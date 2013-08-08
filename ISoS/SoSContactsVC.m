//
//  SoSContactsVC.m
//  ISoS
//
//  Created by Ujwal Manjunath on 7/30/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "SoSContactsVC.h"
#import "SoSaddContactCell.h"
#import "SoSviewContactCell.h"
#import "SoSContactDetailsVC.h"
#import "dataModel.h"

#define NO_OF_STATIC_CELLS 1
#define ROW_LIMIT 6

@interface SoSContactsVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic,strong) NSMutableDictionary *contacts; //stores all contacts

@property (nonatomic,strong) NSArray *titleForHeaders;  //stores header text for each section

@property (nonatomic,strong) NSArray *titleForFooters;  //stores footer text for each section

@property (nonatomic,strong) dataModel *model;

@property ABRecordRef person;

@end

@implementation SoSContactsVC{
    int sectionSelected;
}

#pragma Getter Methods

-(dataModel *)model
{
    if(!_model) _model = [[dataModel alloc] init];
    return _model;
}

-(NSArray *)titleForFooters{
    if(!_titleForFooters)
        _titleForFooters = @[@"You can add upto 5 family members",@"You can add upto 5 friends"];
    
    return _titleForFooters;
}

-(NSArray *)titleForHeaders{
    if(!_titleForHeaders)
        _titleForHeaders = @[@"Family",@"Friends"];
    return _titleForHeaders;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Tableview Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return NO_OF_STATIC_CELLS + [self getCount:[self.model getValueForKeyatIndex:section]];
}

-(NSUInteger) getCount:(id)array
{
   if([array isKindOfClass:[NSString class]])
       return 0;
    else
        return [array count];
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row <  [self getCount:[self.model getValueForKeyatIndex:indexPath.section]]){
        NSString *cellIdentifier = @"viewContact";
        SoSviewContactCell *cell = (SoSviewContactCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SoSviewContactCell" owner:self options:nil]objectAtIndex:0];
        }
        NSDictionary *contact =[[self.model getValueForKeyatIndex:indexPath.section ] objectAtIndex:indexPath.row];
        cell.firstName = [contact valueForKey:@"FirstName"];
        cell.lastName = [contact valueForKey:@"LastName"];
        cell.profilePictureData = [contact valueForKey:@"Imagedata"];
        
        
        return cell;
    }
    else{
        NSString *cellIdentifier = @"addContact";
        SoSaddContactCell *cell= (SoSaddContactCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
       
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SoSaddContactCell" owner:self options:nil]objectAtIndex:0];
        
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Default is 1 if not implemented
    return [[self.model allKeys]count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [self.titleForHeaders objectAtIndex:section];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    return [self.titleForFooters objectAtIndex:section];
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self showPicker:indexPath.section];
    sectionSelected = indexPath.section;
    //
}


#pragma AddressBookUI delegate methods
// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [peoplePicker dismissViewControllerAnimated:YES completion:^{}];
    
}

// Called after a person has been selected by the user.
// Return YES if you want the person to be displayed.
// Return NO  to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{}];
    
    [self setPerson:person];
    
    [self performSegueWithIdentifier:@"addContact" sender: self];
    return NO;
}

// Called after a value has been selected by the user.
// Return YES if you want default action to be performed.
// Return NO to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(void)showPicker:(NSUInteger)section{
    if([self.tableView numberOfRowsInSection:section] >= ROW_LIMIT)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Limit Reached" message:@"You can add only upto 5 members" delegate:self cancelButtonTitle:@"Hide" otherButtonTitles:nil];
        [alert show];
        
    }else{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc]init];
    picker.peoplePickerDelegate= self;
    [self presentViewController:picker animated:YES completion:^{}];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([sender isKindOfClass:[self class]]){
        if([segue.identifier isEqualToString:@"addContact"]){
            if([segue.destinationViewController respondsToSelector:@selector(extractContactInformation:)])
                [segue.destinationViewController performSelector:@selector(extractContactInformation:) withObject:self.person];
        }
    }
}

#pragma Unwind Segue Method

-(IBAction)unwindingMehtod:(UIStoryboardSegue *)segue{
    SoSContactDetailsVC *savedContactDetails = [segue sourceViewController];
 
    
    NSMutableArray *contactArray;
    if([[self.model getValueForKeyatIndex:sectionSelected] isKindOfClass:[NSString class]])
     {
        if([[self.model getValueForKeyatIndex:sectionSelected ]isEqualToString:@"null"])
   
        contactArray = [[NSMutableArray alloc] initWithObjects:savedContactDetails.contact, nil];
       
    }
    else {
        contactArray = [self.model getValueForKeyatIndex:sectionSelected];
        [contactArray addObject:savedContactDetails.contact];
        
    }
    [self.model pushObject:contactArray key:[self.model keyAtIndex:sectionSelected] ];
    
   
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionSelected] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSLog(@"back in parent view");
}

@end
