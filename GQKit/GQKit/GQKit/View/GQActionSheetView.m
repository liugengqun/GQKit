

#import "GQActionSheetView.h"
#import "GQKit.h"
@implementation GQActionSheetCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addTitleView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addTitleView];
    }
    return self;
}

- (void)addTitleView {
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.title.textAlignment  = NSTextAlignmentCenter;
    self.title.textColor = GQ_BlueColor;
    self.title.font = [UIFont systemFontOfSize:14];
    self.title.center = self.center;
    [self addSubview:self.title];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.gq_width, 1)];
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self addSubview:line];
    self.separtline = line;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.separtline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.offset(1);
        make.bottom.equalTo(self);
    }];
}

@end

#define KCell_H 50
#define KSection_H 10
@interface GQActionSheetView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGFloat tableViewH;
@property (strong, nonatomic) UITableView *TableView;
@property (strong, nonatomic) NSMutableArray *dataArrys;
@property (strong, nonatomic) NSString *cancleTitle;
@property (strong, nonatomic) UIColor *cancleColor;

@property (strong, nonatomic) NSArray<UIColor *> *titleColors;

@property (nonatomic, strong) NSString *customCellStr;
@property (nonatomic, strong) NSArray *customCellData;
@end

static NSString * cellId = @"GQActionSheetCell";

@implementation GQActionSheetView

- (instancetype)gq_initWithTitles:(NSArray*)titles withCancleTitle:(NSString*)cancle {
    return [self initWithTitles:titles titleColors:nil withCancleTitle:cancle cancelColor:nil];
}

- (instancetype)gq_initWithTitles:(NSArray*)titles withCancleTitle:(NSString*)cancle cancelColor:(UIColor *)color {
    return [self initWithTitles:titles titleColors:nil withCancleTitle:cancle cancelColor:color];
}

- (instancetype)gq_initWithTitles:(NSArray*)titles titleColors:(NSArray<UIColor *> *)colors withCancleTitle:(NSString*)cancle {
    return [self initWithTitles:titles titleColors:colors withCancleTitle:cancle cancelColor:nil];
}
- (instancetype)gq_initWithTitles:(NSArray*)titles titleColors:(NSArray<UIColor *> *)colors withCancleTitle:(NSString*)cancle cancelColor:(UIColor *)color {
    return [self initWithTitles:titles titleColors:colors withCancleTitle:cancle cancelColor:color];
}
- (instancetype)initWithTitles:(NSArray*)titles titleColors:(NSArray<UIColor *> *)colors withCancleTitle:(NSString*)cancle cancelColor:(UIColor *)color {
    if (self = [super init]) {
        [self initTableViewWith:titles];
        self.cancleTitle = cancle ? cancle : @"取消";
        self.titleColors = colors;
        self.cancleColor = color?:[UIColor redColor];
        [self.TableView reloadData];
    }
    return self;
}

- (void)gq_show {
    UIWindow *keyWind = [UIApplication sharedApplication].keyWindow;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = GQ_RGBA_COLOR(1, 1, 1, 0.3);
    [keyWind addSubview:self];
    
    self.alpha = 0;
    if (self.gq_exampleView) {
        [self addSubview:self.gq_exampleView];
        self.gq_exampleView.frame = CGRectMake(0, GQ_WindowH, GQ_WindowW, self.gq_exampleViewH);
    }
    [UIView animateWithDuration:0.20 animations:^{
        self.alpha = 1;
        self.TableView.frame = CGRectMake(0, GQ_WindowH - self.tableViewH, GQ_WindowW, self.tableViewH);
        if (self.gq_exampleView) {
            self.gq_exampleView.frame = CGRectMake(0, GQ_WindowH-self.tableViewH-self.gq_exampleViewH, GQ_WindowW, self.gq_exampleViewH);
        }
    }];
    
}

- (void)gq_dismiss {
    self.alpha = 1;
    [UIView animateWithDuration:0.20 animations:^{
        self.TableView.frame = CGRectMake(0, GQ_WindowH , GQ_WindowW, self.tableViewH);
        self.alpha = 0;
        if (self.gq_exampleView) {
            self.gq_exampleView.frame = CGRectMake(0, GQ_WindowH, GQ_WindowW, self.gq_exampleViewH);
        }
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

- (void)initTableViewWith:(NSArray*)titles {
    self.tableViewH = (titles.count + 1) * KCell_H + KSection_H + GQ_TabbarSafeBottomMargin;
    
    UITableView * table = [[UITableView alloc]init];
    table.frame = CGRectMake(0, GQ_WindowH, GQ_WindowW, self.tableViewH);
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.scrollEnabled = NO;
    table.delegate = self;
    table.dataSource = self;
    self.TableView = table;

    if ([self.customCellStr length] > 0) {
        [self.TableView registerNib:[UINib nibWithNibName:self.customCellStr bundle:nil] forCellReuseIdentifier:self.customCellStr];
    }
    
    [self addSubview:self.TableView];
    
    self.dataArrys = [NSMutableArray arrayWithArray:titles];
}
- (void)gq_setupCustomCellStr:(NSString *)customCellStr customCellDataArr:(NSArray *)data{
    self.customCellStr = customCellStr;
    self.customCellData = data;
    
    [self initTableViewWith:data];
}
#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.customCellStr length] > 0 ? self.customCellData.count : self.dataArrys.count;
    }else{
        return GQ_iPhoneLH ? 2 : 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.customCellStr length] > 0) {
        if (indexPath.section == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.customCellStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.gq_customCellDataBlock) {
                self.gq_customCellDataBlock(cell, indexPath);
            }
            return cell;
        } else {
            GQActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[GQActionSheetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.title.text =  @"取消";
            cell.title.textColor = GQ_BlueColor;
            cell.separtline.hidden = YES;
            if (indexPath.row == 1) {
                cell.title.text = @"";
            }
            return cell;
        }
    } else {
        GQActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[GQActionSheetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            cell.title.text = self.dataArrys[indexPath.row];
            cell.title.textColor = GQ_BlueColor;
            
            if (self.titleColors.count > indexPath.row) {
                cell.title.textColor = self.titleColors[indexPath.row];
            }
        } else {
            cell.title.text =  _cancleTitle;
            cell.title.textColor = self.cancleColor != nil ? self.cancleColor : GQ_BlueColor;
            cell.separtline.hidden = YES;
            if (indexPath.row == 1) {
                cell.title.text = @"";
            }
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            return;
        }
    }
    if (self.gq_chooseBlock && indexPath.section == 0) {
        NSString * title = self.dataArrys[indexPath.row];
        self.gq_chooseBlock (title, indexPath.row);
    } else if (self.gq_dismissBlock && indexPath.section == 1){
        self.gq_dismissBlock();
    }
    [self gq_dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            return GQ_TabbarSafeBottomMargin;
        }
    }
    return KCell_H;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GQ_WindowW, 10)];
    view.backgroundColor = GQ_BackGroundColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return KSection_H;
    }
    return 0;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self gq_dismiss];
}
@end
