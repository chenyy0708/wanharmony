import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import TitleComponent from '../view/TitleComponent';

@Entry
@Component
struct KnowledgeDetail {
  private courseId: number = router.getParams()?.['courseId'];
  private title: string = router.getParams()?.['title'];

  build() {
    Row() {
      TitleComponent({ title: this.title, onBackPress: () => {
        router.back()
      } })
      Text('知识体系')
    }
  }
}