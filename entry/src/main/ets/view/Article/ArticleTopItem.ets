import promptAction from '@ohos.promptAction';
import { CommonConstant } from '../../common/constant/CommonConstant';
import ArticleViewModel, { ArticleBean, Banner } from '../../viewmodel/ArticleViewModel';
import ArticleItem from './ArticleItem';

@Component
export default struct ArticleTopItem {
  @State topData: Array<ArticleBean> = [];

  aboutToAppear() {
    ArticleViewModel.getArticleTopList()
      .then((data: ArticleBean[]) => {
        this.topData = data;
      })
      .catch((err: string | Resource) => {
        promptAction.showToast({
          message: err,
          duration: CommonConstant.ANIMATION_DURATION
        });
      })
  }

  build() {
    if (this.topData.length > 0) {
      Column() {
        ForEach(this.topData, (item: ArticleBean) => {
          ArticleItem({ articleBean: item, isTop: true })
            .backgroundColor($r('app.color.white'))
            .width('100%')
        }, (item: ArticleBean, index?: number) => JSON.stringify(item) + index)
      }
    }
  }
}