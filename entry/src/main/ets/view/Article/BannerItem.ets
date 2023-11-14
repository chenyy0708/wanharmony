import promptAction from '@ohos.promptAction';
import { CommonConstant } from '../../common/constant/CommonConstant';
import Logger from '../../common/utils/Logger';
import ArticleViewModel, { Banner } from '../../viewmodel/ArticleViewModel';

@Component
export default struct BannerItem {
  @State bannerData: Array<Banner> = [];
  @Consume('isBig') @Watch('onStateChange') isBig: boolean

  private onStateChange() {
    Logger.debug('BannerItem','isBig:' + this.isBig)
  }

  aboutToAppear() {
    ArticleViewModel.getBannerList()
      .then((data: Banner[]) => {
        this.bannerData = data;
        Logger.debug("ArticleList", `BannerItem  bannerData:${this.bannerData.length}`)
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
            .onClick(()=>{
              this.isBig = !this.isBig
            })
        })
      }
      .width(CommonConstant.FULL_WIDTH)
      .height(150)
    }
  }
}