/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstant, CommonConstant as Const } from '../common/constant/CommonConstant';
import { ArticleBean, NewsData, NewsFile } from '../viewmodel/NewsViewModel';

/**
 * The news list item component.
 */
@Component
@Preview
export default struct NewsItem {
  private articleBean: ArticleBean = new ArticleBean();
  private isTop : boolean = false;

  build() {
    Column() {
      Row() {
        if(this.isTop) {
          Text('置顶')
            .borderColor('#ff0000')
            .fontSize(11)
            .fontColor('#333333')
            .padding({ left: 3, right: 3, top: 2, bottom: 2 })
            .borderRadius(2)
            .borderWidth(1)
            .margin({ right: 5 })
        }
        Text(this.articleBean.chapterName || '').fontSize(11).fontColor('#666666')
        Blank()
        Text(this.articleBean.niceDate || '').fontSize(11).fontColor('#666666')
      }.width(Const.FULL_WIDTH)

      Text(this.articleBean.title || '')
        .fontSize(13)
        .fontColor('#333333')
        .margin({ top: 10, bottom: 10 })
        .width(Const.FULL_WIDTH)

      Row() {
        Text(this.articleBean.superChapterName || '').fontSize(11).fontColor('#666666')
        Blank()
      }.width(Const.FULL_WIDTH)
    }.padding(10)

  }
}