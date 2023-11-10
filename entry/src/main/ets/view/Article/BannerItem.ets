import promptAction from '@ohos.promptAction';
import { CommonConstant } from '../../common/constant/CommonConstant';
import ArticleViewModel, { Banner } from '../../viewmodel/ArticleViewModel';

@Component
export default struct BannerItem {
  @State bannerData: Array<Banner> = [];

  aboutToAppear() {
    ArticleViewModel.getBannerList()
      .then((data: Banner[]) => {
        this.bannerData = data;
      })
      .catch((err: string | Resource) => {
        promptAction.showToast({
          message: err,
        });
      })
  }

  build() {
    if(this.bannerData.length > 0) {
      Swiper() {
        ForEach(this.bannerData, (item: Banner) => {
          Image(item.imagePath)
            .width(CommonConstant.FULL_WIDTH)
            .height(CommonConstant.FULL_WIDTH)
        })
      }
      .width(CommonConstant.FULL_WIDTH)
      .height(150)
    }
  }
}