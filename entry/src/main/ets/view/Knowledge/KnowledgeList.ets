import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { CommonConstant } from '../../common/constant/CommonConstant';
import KnowledgeViewMode, { KnowledgeBean } from '../../viewmodel/KnowledgeViewModel';

@Component
export default struct KnowledgeList {
  @State knowledgeData: Array<KnowledgeBean> = [];

  aboutToAppear() {
    KnowledgeViewMode.getKnowledgeList()
      .then((datas: KnowledgeBean[]) => {
        this.knowledgeData = datas;
      })
      .catch((err: string | Resource) => {
        promptAction.showToast({
          message: err,
          duration: CommonConstant.ANIMATION_DURATION
        });
      })
  }

  build() {
    List() {
      ForEach(this.knowledgeData, (item: KnowledgeBean, index) => {
        ListItem() {
          KnowledgeItem({ knowledgeBean: item })
        }
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
struct KnowledgeItem {
  @Prop knowledgeBean: KnowledgeBean

  build() {
    Row() {
      Column() {
        Text(this.knowledgeBean.name).fontSize(14).fontColor('#333').margin({ bottom: 10 })
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.knowledgeBean.children || [], (item: KnowledgeBean, index) => {
            Text(item.name)
              .fontSize(11)
              .fontColor('#666')
              .borderWidth(0.5)
              .borderColor('#ff3333')
              .borderRadius(2)
              .padding({ left: 2, right: 2, bottom: 1, top: 1 })
              .margin({ right: 4, top: 5 })
          }, (item, index) => JSON.stringify(item) + index)
        }
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Image($r('app.media.ic_right_arrow')).height(20).width(20)
    }
    .padding(10)
    .onClick(() => {
      router.pushUrl({
        url: 'pages/KnowledgeDetail',
        params: { courseId: this.knowledgeBean.courseId, title: this.knowledgeBean.name }
      })
    })
  }
}