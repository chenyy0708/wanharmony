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
import { CommonConstant as Const, PageState } from '../../common/constant/CommonConstant';
import ArticleItem from './ArticleItem';
import CustomRefreshLoadLayout from '../CustomRefreshLoadLayout';
import NewsViewModel, { ArticleBean, CustomRefreshLoadLayoutClass } from '../../viewmodel/ArticleViewModel';
import ArticleModel from '../../viewmodel/ArticleModel';
import BannerItem from './BannerItem';
import ArticleTopItem from './ArticleTopItem';
import Logger from '../../common/utils/Logger';
import LoadMoreLayout from '../LoadMoreLayout';
import NoMoreLayout from '../NoMoreLayout';

/**
 * The news list component.
 */
@Component
export default struct ArticleList {
  @State articleModel: ArticleModel = new ArticleModel();
  @Link currentIndex: number;

  loadArticleData(isLoadMore : boolean) {
    if(isLoadMore) {
      this.articleModel.currentPage++;
    } else {
      this.articleModel.currentPage = 1;
    }
    this.articleModel.currentPage
    NewsViewModel.getArticleList(this.articleModel.currentPage, Const.GET_ARTICLE_LIST)
      .then((data: ArticleBean[]) => {
        this.articleModel.pageState = PageState.Success;
        if(isLoadMore) {
          this.articleModel.articleData = this.articleModel.articleData.concat(data);
        } else {
          this.articleModel.articleData = data;
        }
        this.articleModel.isRefreshing = false;
        this.articleModel.isCanLoadMore = true;
        Logger.debug("ArticleList", `ArticleList  articleData:${this.articleModel.articleData.length}`)
      })
      .catch((err: string | Resource) => {
        promptAction.showToast({
          message: err,
          duration: Const.ANIMATION_DURATION
        });
        this.articleModel.isRefreshing = false;
        this.articleModel.isCanLoadMore = true;
        this.articleModel.pageState = PageState.Fail;
      });
  }

  aboutToAppear() {
    this.loadArticleData(false);
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
  }

  @Builder LoadingLayout() {
    CustomRefreshLoadLayout({ customRefreshLoadClass: new CustomRefreshLoadLayoutClass(true,
      $r('app.media.ic_pull_up_load'), $r('app.string.pull_up_load_text'), this.articleModel.pullDownRefreshHeight) })
  }

  @Builder ListLayout() {
    Refresh({ refreshing: this.articleModel.isRefreshing }) {
      List() {
        ListItem() {
          BannerItem()
        }

        ListItem() {
          ArticleTopItem()
        }

        ForEach(this.articleModel.articleData, (item: ArticleBean) => {
          ListItem() {
            ArticleItem({ articleBean: item })
          }
          .backgroundColor($r('app.color.white'))
          .width('100%')
        }, (item: ArticleBean, index?: number) => JSON.stringify(item) + index)
        ListItem() {
          if (this.articleModel.hasMore) {
            LoadMoreLayout()
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
      .onScrollIndex((start, end) => {
        Logger.debug("ArticleList", `onScrollIndex  start:${start}----end:${end}`)
        if (this.articleModel.hasMore && this.articleModel.isCanLoadMore && end >= this.articleModel.articleData.length + 2) {
          Logger.debug("ArticleList", `加载更多`)
          this.articleModel.isCanLoadMore = false;
          this.loadArticleData(true);
        }
      })
    }
    .onStateChange((state: RefreshStatus) => {
      Logger.debug("ArticleList", '刷新state:' + state.toString())
    })
    .onRefreshing(() => {
      this.articleModel.isRefreshing = true;
      this.loadArticleData(false);
      Logger.debug("ArticleList", 'onRefreshing:')
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