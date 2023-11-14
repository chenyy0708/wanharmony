import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import TitleComponent from '../view/TitleComponent';
import KnowledgeViewMode from '../viewmodel/KnowledgeViewModel';
import { ArticleBean } from '../viewmodel/ArticleViewModel';
import { CommonConstant } from '../common/constant/CommonConstant';
import ArticleItem from '../view/Article/ArticleItem';

@Entry
@Component
struct KnowledgeDetail {
  private courseId: number = router.getParams()?.['courseId'];
  private title: string = router.getParams()?.['title'];
  @State knowledgeData: Array<ArticleBean> = [];

  aboutToAppear() {
    KnowledgeViewMode.getKnowledgeDetail(this.courseId)
      .then((datas: ArticleBean[]) => {
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
    Column() {
      TitleComponent({ title: this.title, onBackPress: () => {
        router.back()
      } })
      List() {
        ForEach(this.knowledgeData, (item: ArticleBean, index) => {
          ListItem() {
            ArticleItem({ articleBean: item })
          }
          .backgroundColor($r('app.color.white'))
        }, (item, index) => JSON.stringify(item) + index)
      }
    }
  }
}