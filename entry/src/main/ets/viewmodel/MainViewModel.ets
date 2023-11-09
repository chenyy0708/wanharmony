export class TabBean {
  icon: Resource;
  name: string;
}

class MainViewModel {
  getTabList(): TabBean[] {
    return [
      {
        icon: $r('app.media.ic_home'), name: '首页'
      },
      {
        icon: $r('app.media.ic_knowledge'), name: '体系'
      },
      {
        icon: $r('app.media.ic_wechat'), name: '公众号'
      },
      {
        icon: $r('app.media.ic_navigation'), name: '导航'
      },
      {
        icon: $r('app.media.ic_project'), name: '项目'
      }
    ];
  }
}

let mainViewModel = new MainViewModel();

export default mainViewModel as MainViewModel;