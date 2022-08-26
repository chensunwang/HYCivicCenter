//
//  HYCommonProblemViewController.m
//  HelloFrame
//
//  Created by nuchina on 2022/1/7.
//
//  常见问题页面

#import "HYCommonProblemViewController.h"
#import "HYCommonProblemTableViewCell.h"

@interface HYCommonProblemViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasArr;

@end

NSString *const commonProblemCell = @"questionCell";
@implementation HYCommonProblemViewController

- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[HYCommonProblemTableViewCell class] forCellReuseIdentifier:commonProblemCell];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    
    [self traitCollectionDidChange:nil];
}

- (void)loadData {
    [HttpRequest getPathZWBS:@"phone/item/event/getItemInfoByItemCode" params:@{@"itemCode": _itemCode} resultBlock:^(id  _Nullable responseObject, NSError * _Nullable error) {
        SLog(@" 常见问题 == %@ ", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            self.datasArr = [HYQuestionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"question"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
}

- (NSMutableArray *)datasArr {
    
    if (!_datasArr) {
        _datasArr = [NSMutableArray array];
    }
    return _datasArr;
    
}

#pragma UItableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYCommonProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commonProblemCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.problemModel = self.datasArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYQuestionModel *model = self.datasArr[indexPath.row];
    CGRect questionRect = [model.question boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 94, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName: MFONT(14)}
                                                       context:nil];
    CGRect answerRect = [model.answer boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 94, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName: MFONT(15)} context:nil];
    return questionRect.size.height + answerRect.size.height + 68;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
