import router from '@ohos.router';

@Entry
@Component
struct WebPage {
  private url: string = router.getParams()?.['url'];
  private title: string = router.getParams()?.['title'];
  controller: WebController = new WebController();

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(26)
          .height(26)
          .onClick(() => {
            router.back()
          })
          .margin({ left: 10, right: 10 })
        Text(this.title).fontColor('#333333').fontSize(14).fontWeight(700).maxLines(1)
      }
      .backgroundColor($r('app.color.white'))
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .height(50)
      Divider().backgroundColor($r('app.color.dividerColor')).height(0.5)
      Web({ src: this.url, controller: this.controller })
    }
    .width('100%')
    .height('100%')
  }
}