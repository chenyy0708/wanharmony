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

import promptAction from '@ohos.promptAction';
import { CommonConstant, CommonConstant as Const, PageState } from '../common/constant/CommonConstant';
import ArticleItem from './ArticleItem';
import LoadMoreLayout from './LoadMoreLayout';
import RefreshLayout from './RefreshLayout';
import CustomRefreshLoadLayout from './CustomRefreshLoadLayout';
import { listTouchEvent } from '../common/utils/PullDownRefresh';
import NewsViewModel, { ArticleBean, Banner, CustomRefreshLoadLayoutClass } from '../viewmodel/ArticleViewModel';
import NoMoreLayout from './NoMoreLayout';
import ArticleModel from '../viewmodel/ArticleModel';

/**
 * The news list component.
 */
@Component
export default struct ArticleList {
  @State articleModel: ArticleModel = new ArticleModel();
  @Watch('changeCategory') @Link currentIndex: number;

  changeCategory() {
    this.articleModel.currentPage = 1;
    NewsViewModel.getArticleList(this.articleModel.currentPage, this.articleModel.pageSize, Const.GET_ARTICLE_LIST)
      .then((data: ArticleBean[]) => {
        this.articleModel.pageState = PageState.Success;
        this.articleModel.currentPage++;
        this.articleModel.hasMore = true;
        this.articleModel.articleData = data;
      })
      .catch((err: string | Resource) => {
        promptAction.showToast({
          message: err,
          duration: Const.ANIMATION_DURATION
        });
        this.articleModel.pageState = PageState.Fail;
      });
  }

  aboutToAppear() {
    // Request news data.
    this.changeCategory();
    NewsViewModel.getBannerList()
      .then((data: Banner[]) => {
        this.articleModel.bannerData = data;
      })
      .catch((err: string | Resource) => {
        promptAction.showToast({
          message: err,
          duration: Const.ANIMATION_DURATION
        });
        this.articleModel.pageState = PageState.Fail;
      })
    NewsViewModel.getArticleTopList()
      .then((data: ArticleBean[]) => {
        this.articleModel.topData = data;
      })
      .catch((err: string | Resource) => {
        promptAction.showToast({
          message: err,
          duration: Const.ANIMATION_DURATION
        });
      })
  }

  build() {
    Column() {
      if (this.articleModel.pageState === PageState.Success) {
        this.ListLayout()
      } else if (this.articleModel.pageState === PageState.Loading) {
        this.LoadingLayout()
      } else {
        this.FailLayout()
      }
    }
    .width(Const.FULL_WIDTH)
    .height(Const.FULL_HEIGHT)
    .justifyContent(FlexAlign.Center)
    .onTouch((event: TouchEvent | undefined) => {
      if (event) {
        if (this.articleModel.pageState === PageState.Success) {
          listTouchEvent(this.articleModel, event);
        }
      }
    })
  }

  @Builder LoadingLayout() {
    CustomRefreshLoadLayout({ customRefreshLoadClass: new CustomRefreshLoadLayoutClass(true,
      $r('app.media.ic_pull_up_load'), $r('app.string.pull_up_load_text'), this.articleModel.pullDownRefreshHeight) })
  }

  @Builder ListLayout() {
    List() {
      ListItem() {
        RefreshLayout({
          refreshLayoutClass: new CustomRefreshLoadLayoutClass(this.articleModel.isVisiblePullDown, this.articleModel.pullDownRefreshImage,
            this.articleModel.pullDownRefreshText, this.articleModel.pullDownRefreshHeight)
        })
      }

      ListItem() {
        Swiper() {
          ForEach(this.articleModel.bannerData, (item: Banner) => {
            Image(item.imagePath)
              .width(Const.FULL_WIDTH)
              .height(Const.FULL_WIDTH)
          })
        }
        .width(Const.FULL_WIDTH)
        .height(150)
      }

      ForEach(this.articleModel.topData, (item: ArticleBean) => {
        ListItem() {
          ArticleItem({ articleBean: item, isTop : true })
        }
        .backgroundColor($r('app.color.white'))
        .width('100%')
      }, (item: ArticleBean, index?: number) => JSON.stringify(item) + index)
      ForEach(this.articleModel.articleData, (item: ArticleBean) => {
        ListItem() {
          ArticleItem({ articleBean: item })
        }
        .backgroundColor($r('app.color.white'))
        .width('100%')
      }, (item: ArticleBean, index?: number) => JSON.stringify(item) + index)
      ListItem() {
        if (this.articleModel.hasMore) {
          LoadMoreLayout({
            loadMoreLayoutClass: new CustomRefreshLoadLayoutClass(this.articleModel.isVisiblePullUpLoad, this.articleModel.pullUpLoadImage,
              this.articleModel.pullUpLoadText, this.articleModel.pullUpLoadHeight)
          })
        } else {
          NoMoreLayout()
        }
      }
    }
    .width('100%')
    .height(Const.FULL_HEIGHT)
    .divider({
      color: $r('app.color.dividerColor'),
      strokeWidth: Const.NewsListConstant_LIST_DIVIDER_STROKE_WIDTH,
      endMargin: Const.NewsListConstant_LIST_MARGIN_RIGHT
    })
    // Remove the rebound effect.
    .edgeEffect(EdgeEffect.None)
    .offset({ x: 0, y: `${this.articleModel.offsetY}${CommonConstant.LIST_OFFSET_UNIT}` })
    .onScrollIndex((start: number, end: number) => {
      // Listen to the first index of the current list.
      this.articleModel.startIndex = start;
      this.articleModel.endIndex = end;
    })
  }

  @Builder FailLayout() {
    Image($r('app.media.none'))
      .height(Const.NewsListConstant_NONE_IMAGE_SIZE)
      .width(Const.NewsListConstant_NONE_IMAGE_SIZE)
    Text($r('app.string.page_none_msg'))
      .opacity(Const.NewsListConstant_NONE_TEXT_opacity)
      .fontSize(Const.NewsListConstant_NONE_TEXT_size)
      .fontColor($r('app.color.fontColor_text3'))
      .margin({ top: Const.NewsListConstant_NONE_TEXT_margin })
  }
}