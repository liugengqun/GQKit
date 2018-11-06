<p>GQKit包含项目基类控制器（包含网络请求分页、上拉刷新、下拉加载、无状态页覆盖、导航栏隐藏以及渐变控制）、Foundation以及UIkit的category、其他工具类、网络请求封装（包含loading动画控制）、个别常用控件封装等，使用GQkit可很快进行新项目开发（但还需根据实际项目数据、网络进行稍微调整）。<p>

<p>基类控制器使用<p>
<pre><code>
self.gq_objClass = [SCDynamicModel class];
self.gq_isGetRequest = YES;
self.gq_enableTableHeaderFooter = YES;
self.gq_getRequestUrlBlock = ^NSString *(NSUInteger pageIndex){
NSString *url = [NSString stringWithFormat:@"/news/queryNowList?curPage=%zd&isPaging=1",pageIndex];  // isPaging=1 支持分页 curPage分页参数
return url;
};
[self gq_refresh];
</code></pre>
