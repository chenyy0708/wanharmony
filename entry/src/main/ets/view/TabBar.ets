/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstant as Const } from '../common/constant/CommonConstant';
import MainViewModel, { TabBean } from '../viewmodel/MainViewModel';
import ArticleList from './Article/ArticleList';

/**
 * The tabBar component.
 */
@Component
@Preview
export default struct TabBar {
  @State tabBarArray: TabBean[] = MainViewModel.getTabList();
  @State currentIndex: number = 0;
  @State currentPage: number = 1;
  @State isBig: boolean = false;

  @Builder
  TabBuilder(index: number, tabBean: TabBean) {
    Column() {
      Text(this.tabBarArray[index].name)
        .fontWeight(this.currentIndex === index ? Const.TabBars_SELECT_TEXT_FONT_WEIGHT : Const.TabBars_UN_SELECT_TEXT_FONT_WEIGHT)
        .fontSize(14)
        .fontColor($r('app.color.fontColor_text3')).margin({ bottom: 2 })
      Image(tabBean.icon).height(20).width(20)
    }
  }

  aboutToAppear() {
  }

  build() {
    Tabs() {
      ForEach(this.tabBarArray, (tabsItem: TabBean, index) => {
        TabContent() {
          Column() {
            if (index === 0) {
              ArticleList({ currentIndex: $currentIndex })
            } else {
              Text(tabsItem.name)
                .onClick(() => {
                  this.isBig = !this.isBig
                })
                .backgroundColor('#00ff00')
                .animation({
                  duration: 1000,
                  tempo: 3.0,
                  delay: 0,
                  curve: Curve.Linear,
                  playMode: PlayMode.Normal,
                  iterations: 1
                })
                .height(this.isBig ? 400 : 200)

            }
          }
        }
        .tabBar(this.TabBuilder(index, tabsItem))
      }, (item: TabBean) => JSON.stringify(item));
    }
    .barHeight(50)
    .barPosition(BarPosition.End)
    .barMode(BarMode.Fixed)
    .barWidth(Const.TabBars_BAR_WIDTH)
    .backgroundColor($r('app.color.white'))
    .onChange((index: number) => {
      this.currentIndex = index;
      this.currentPage = 1;
    })
    .vertical(false)
  }
}