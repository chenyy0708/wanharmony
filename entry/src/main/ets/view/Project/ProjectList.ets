import promptAction from '@ohos.promptAction';
import display from '@ohos.display';
import { CommonConstant } from '../../common/constant/CommonConstant';
import { fetch } from '../../common/utils/FetchUtil';
import Logger from '../../common/utils/Logger';
import { ArticleBean, ResponseResult } from '../../viewmodel/ArticleViewModel';
import { KnowledgeBean } from '../../viewmodel/KnowledgeViewModel';
import { GlobalContext } from '../../utils/GlobalContext';

@Component
export default struct ProjectList {
  @State projectTabs: Array<KnowledgeBean> = [];
  @State currentIndex: number = 0;

  aboutToAppear() {
    let url = `${CommonConstant.SERVER}/project/tree/json`;
    fetch({ url }).then((response: ResponseResult) => {
      if (response.errorCode === 0) {
        this.projectTabs = response.data || [];
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
      ForEach(this.projectTabs, (tabsItem: KnowledgeBean, index) => {
        TabContent() {
          ProjectContent({ item: tabsItem })
        }
        .tabBar(tabsItem.name)
      }, (item: KnowledgeBean) => JSON.stringify(item));
    }
    .barHeight(50)
    .barPosition(BarPosition.Start)
    .width('100%')
    .barMode(BarMode.Scrollable)
    .backgroundColor('#FFF')
    .onChange((index: number) => {
      this.currentIndex = index;
    })
    .vertical(false)
  }

  @Builder
  TabBuilder(index: number, tabBean: KnowledgeBean) {
    Text(tabBean.name || '')
      .fontSize(14)
      .width(100)
      .height('100%')
      .backgroundColor('#F1F3F5')
      .textAlign(TextAlign.Center)
      .fontColor(this.currentIndex === index ? '#333' : '#666')
  }
}

@Component
struct ProjectContent {
  @Prop item: KnowledgeBean
  @State datas: Array<ArticleBean> = []

  aboutToAppear() {
    let url = `${CommonConstant.SERVER}/project/list/1/json?cid=${this.item.id}`;
    fetch({ url }).then((response: ResponseResult) => {
      if (response.errorCode === 0) {
        this.datas = response.data?.datas || [];
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
    List() {
      ForEach(this.datas, (item: ArticleBean, index) => {
        ListItem() {
          ProjectItem({ item: item })
        }
        .padding(10)
        .height(200)
      }, (item, index) => JSON.stringify(item) + index)
    }
    .divider({
      color: $r('app.color.dividerColor'),
      strokeWidth: CommonConstant.NewsListConstant_LIST_DIVIDER_STROKE_WIDTH,
      endMargin: CommonConstant.NewsListConstant_LIST_MARGIN_RIGHT
    })
  }
}

@Component
struct ProjectItem {
  @Prop item: ArticleBean
  private deviceDisplay: display.Display = GlobalContext.getContext().getObject('display') as display.Display;

  aboutToAppear() {
    Logger.debug('ProjectItem',"width:" + this.deviceDisplay.width)
  }

  build() {
    Row() {
      Image(this.item.envelopePic || '').width(100).height(180).objectFit(ImageFit.Cover)
      Column() {
        Text(this.item.title).fontColor('#333').fontSize(14).margin({ top: 10 })
        Text(this.item.desc).fontColor('#666').fontSize(12).margin({ top: 10, bottom: 10 }).maxLines(2)
        Blank()
        Column() {
          Row() {
            Text(`${this.item.author}`).fontColor('#666').fontSize(12)
            Blank()
            Text(this.item.niceDate).fontColor('#666').fontSize(12)
          }

          Image($r('app.media.ic_love')).width(20).height(20)
        }
        .alignItems(HorizontalAlign.End)
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 10 })
      .height(200)
      .width(this.deviceDisplay.width - 100 - 20)
    }
    .alignItems(VerticalAlign.Top)
  }
}
