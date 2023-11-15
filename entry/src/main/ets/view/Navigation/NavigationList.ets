import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { CommonConstant } from '../../common/constant/CommonConstant';
import { fetch } from '../../common/utils/FetchUtil';
import Logger from '../../common/utils/Logger';
import { ArticleBean, ResponseResult } from '../../viewmodel/ArticleViewModel';

@Component
export default struct NavigationList {
  @State navigationData: Array<NavigationBean> = [];
  @State currentIndex: number = 0;

  aboutToAppear() {
    let url = `${CommonConstant.SERVER}/navi/json`;
    fetch({ url }).then((response: ResponseResult) => {
      if (response.errorCode === 0) {
        this.navigationData = response.data || [];
      } else {
        Logger.error('getNewsList failed', JSON.stringify(response));
        promptAction.showToast({ message: $r('app.string.page_none_msg') })
      }
    }).catch((err: Error) => {
      Logger.error('getNewsList failed', JSON.stringify(err));
      promptAction.showToast({ message: $r('app.string.http_error_message') })
    });
  }

  build() {
    Tabs() {
      ForEach(this.navigationData, (tabsItem: NavigationBean, index) => {
        TabContent() {
          NavigationItem({ item: tabsItem })
        }
        .tabBar(this.TabBuilder(index, tabsItem))
      }, (item: NavigationBean) => JSON.stringify(item));
    }
    .barHeight('100%')
    .barPosition(BarPosition.Start)
    .barMode(BarMode.Scrollable)
    .barWidth('25%')
    .backgroundColor('#FFF')
    .onChange((index: number) => {
      this.currentIndex = index;
    })
    .vertical(true)
  }

  @Builder
  TabBuilder(index: number, tabBean: NavigationBean) {
    Text(tabBean.name || '')
      .fontSize(14)
      .width('100%')
      .height(50)
      .backgroundColor('#F1F3F5')
      .textAlign(TextAlign.Center)
      .fontColor(this.currentIndex === index ? '#333' : '#666')
  }
}

@Component
struct NavigationItem {
  @Prop item: NavigationBean

  build() {
    Column() {
      Text(this.item.name).fontSize(14).fontColor("#333").margin({ top: 10 })
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.item.articles || [], (item: ArticleBean, index) => {
          Text(item.title)
            .fontSize(13)
            .fontColor('#666')
            .backgroundColor('#F1F3F5')
            .padding({ left: 5, right: 5, bottom: 8, top: 8 })
            .margin({ right: 10, top: 10 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/WebPage', params: { url: item.link, title: item.title } })
            })
        }, (item, index) => JSON.stringify(item) + index)
      }
      .margin({ left: 20 })
    }
    .justifyContent(FlexAlign.Start)
    .height('100%')
  }
}

export interface NavigationBean {
  articles?: ArticleBean[];
  cid?: number;
  name?: string;
}