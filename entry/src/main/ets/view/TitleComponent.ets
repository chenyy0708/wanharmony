@Component
export default struct TitleComponent {
  title: string;
  onBackPress: () => void;

  build() {
    Row() {
      Image($r('app.media.ic_back'))
        .width(26)
        .height(26)
        .onClick(() => {
          this.onBackPress();
        })
        .margin({ left: 10, right: 10 })
      Text(this.title).fontColor('#333333').fontSize(14).fontWeight(700).maxLines(1)
    }
    .backgroundColor($r('app.color.white'))
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .height(50)
  }
}